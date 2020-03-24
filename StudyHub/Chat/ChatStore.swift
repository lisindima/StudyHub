//
//  ChatStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase
import Alamofire

class ChatStore: ObservableObject {
    
    @Published var chatList: [String] = [String]()
    @Published var dataMessages: [DataMessages] = [DataMessages]()
    @Published var statusChat: StatusChat = .loading
    
    static let shared = ChatStore()
    
    var isNotRead: Int = 0
    
    let legacyServerKey: String = "AIzaSyCsYkJqBBzCEVPIRuN4mi0eRr5-x5x-HLs"
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func loadMessageList() {
        db.collection("chatRoom").document("Test2").collection("messages").order(by: "dateMsg", descending: false).addSnapshotListener { querySnapshot, err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for item in querySnapshot!.documentChanges {
                if item.type == .added {
                    let id = item.document.documentID
                    let user = item.document.get("user") as! String
                    let message = item.document.get("message") as! String
                    let idUser = item.document.get("idUser") as! String
                    let timeStamp = item.document.get("dateMsg") as! Timestamp
                    let dateMessage = timeStamp.dateValue()
                    let isRead = item.document.get("isRead") as! Bool
                    self.dataMessages.append(DataMessages(id: id, user: user, message: message, idUser: idUser, dateMessage: dateMessage, isRead: isRead))
                }
                if item.type == .modified {
                    self.dataMessages = self.dataMessages.map { eachData -> DataMessages in
                        var data = eachData
                        if data.id == item.document.documentID {
                            data.user = item.document.get("user") as! String
                            data.message = item.document.get("message") as! String
                            data.idUser = item.document.get("idUser") as! String
                            data.isRead = item.document.get("isRead") as! Bool
                            return data
                        } else {
                            return eachData
                        }
                    }
                }
                if item.type == .removed {
                    var removeRowIndex = 0
                    for index in self.dataMessages.indices {
                        if self.dataMessages[index].id == item.document.documentID {
                            removeRowIndex = index
                        }
                    }
                    self.dataMessages.remove(at: removeRowIndex)
                }
            }
        }
    }
    
    func addMessageDB(message: String, user: String, idUser: String) {
        db.collection("chatRoom").document("Test2").collection("messages").addDocument(data: [
            "message": message,
            "user": user,
            "idUser": idUser,
            "dateMsg": Timestamp(),
            "isRead": false
        ]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    func updateData(id: String, isRead: Bool) {
        db.collection("chatRoom").document("Test2").collection("messages").document(id).updateData(["isRead": isRead]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                print("Сообщения прочитаны!")
            }
        }
    }
    
    func getDataFromDatabaseListenChat() {
        statusChat = .loading
        db.collection("chatRoom").addSnapshotListener { querySnapshot, err in
            if err != nil {
                self.statusChat = .emptyChat
                print((err?.localizedDescription)!)
                return
            } else if querySnapshot!.isEmpty {
                self.statusChat = .emptyChat
            } else if let querySnapshot = querySnapshot {
                self.chatList = querySnapshot.documents.map { $0.documentID }
                self.statusChat = .showChat
            }
        }
    }
    
    func sendMessage(chatStore: ChatStore, token: String, title: String, body: String) {
        addMessageDB(message: body, user: title, idUser: currentUser!.uid)
        
        isNotRead += 1
        
        let parameters: Parameters = [
            "to": token,
            "priority": "high",
            "notification": [
                "title": title,
                "body": body,
                "sound": "default",
                "badge": isNotRead
            ],
            "data": [
                "user": "test_id"
            ]
        ]
        
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization("key=\(legacyServerKey)")
        ]
        
        let encoding = JSONEncoding.prettyPrinted
        
        AF.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { response in
                print(response)
        }
    }
    
    func checkRead() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        for data in dataMessages {
            if currentUser!.uid != data.idUser && !data.isRead {
                self.updateData(id: data.id, isRead: true)
            }
        }
    }
}

enum StatusChat {
    case loading
    case emptyChat
    case showChat
}

struct DataMessages: Identifiable {
    var id: String
    var user: String
    var message: String
    var idUser: String
    var dateMessage: Date
    var isRead: Bool = false
}
