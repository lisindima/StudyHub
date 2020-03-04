//
//  ChatStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

class ChatStore: ObservableObject {
    
    @Published var chatList: Array = [String]()
    @Published var messages: Array = [DataMessages]()
    @Published var statusChat: StatusChat = .loading
    
    static let shared = ChatStore()
    
    var fcmToken: String = Messaging.messaging().fcmToken!
    let currentUid = Auth.auth().currentUser!.uid
    let legacyServerKey = "AIzaSyCsYkJqBBzCEVPIRuN4mi0eRr5-x5x-HLs"
    
    init() {
        loadMessageList()
    }
    
    func loadMessageList() {
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("messages").order(by: "dateMsg", descending: false).addSnapshotListener { (querySnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for item in querySnapshot!.documentChanges {
                if item.type == .added {
                    let user = item.document.get("user") as! String
                    let message = item.document.get("message") as! String
                    let idUser = item.document.get("idUser") as! String
                    let timeStamp = item.document.get("dateMsg") as! Timestamp
                    let aDate = timeStamp.dateValue()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let dateMessage = formatter.string(from: aDate)
                    let isRead = item.document.get("isRead") as! Bool
                    let id = item.document.documentID
                    self.messages.append(DataMessages(id: id, user: user, message: message, idUser: idUser, dateMessage: dateMessage, isRead: isRead))
                }
            }
        }
    }
    
    func addMessageDB(message: String, user: String, idUser: String) {
        let db = Firestore.firestore()
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
            print("Сообщение отправлено!")
        }
    }
    
    func updateData(id: String, isRead: Bool) {
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("messages").document(id).updateData(["isRead": isRead]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("Сообщения прочитаны!")
            }
        }
    }
    
    func getDataFromDatabaseListenChat() {
        statusChat = .loading
        let db = Firestore.firestore()
        db.collection("chatRoom").addSnapshotListener { (querySnapshot, err) in
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
    
    func sendMessage(datas: ChatStore, token: String, title: String, body: String) {
        self.addMessageDB(message: body, user: title, idUser: Auth.auth().currentUser!.uid)
        var isNotRead: Int = 0
        for messages in datas.messages {
            if !messages.isRead && title == messages.idUser {
                isNotRead += 1
            }
        }
        isNotRead += 1
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to": token,
                                           "priority": "high",
                                           "notification": ["title": title, "body": body, "sound": "default", "badge": isNotRead],
                                           "data": ["user": "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
    func checkRead() {
        print("Проверка на чтение")
        UIApplication.shared.applicationIconBadgeNumber = 0
        for data in messages {
            if self.currentUid != data.idUser && data.isRead == false {
                self.updateData(id: data.id, isRead: true)
            }
        }
    }
    
    func updateFcmToken() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(currentUser.uid)
        docRef.updateData([
            "fcmToken": fcmToken
        ]) { err in
            if let err = err {
                print("fcmToken не обновлен: \(err)")
            } else {
                print("fcmToken обновлен!")
            }
        }
    }
}

enum StatusChat {
    case loading
    case emptyChat
    case showChat
}

struct DataMessages: Codable, Hashable, Identifiable {
    
    var id: String
    var user: String
    var message: String
    var idUser: String
    var dateMessage: String
    var isRead: Bool = false
}
