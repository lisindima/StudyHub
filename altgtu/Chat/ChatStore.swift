//
//  ChatStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

class ChatStore: ObservableObject {
    
    @Published var chatList: Array = [String]()
    @Published var messages: Array = [DataMessages]()
    @Published var statusChat: StatusChat = .loading
    
    static let shared = ChatStore()
    
    func loadMessageList() {
        print("Чат")
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("msg").order(by: "dateMsg")
            .addSnapshotListener { (querySnapshot, err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                for item in querySnapshot!.documentChanges {
                    if item.type == .added {
                        let user = item.document.get("user") as! String
                        let message = item.document.get("msg") as! String
                        let idUser = item.document.get("idUser") as! String
                        let dateMessage = item.document.get("dateMsg") as! String
                        let id = item.document.documentID
                        self.messages.append(DataMessages(id: id, user: user, message: message, idUser: idUser, dateMessage: dateMessage))
                    }
                }
        }
    }
    
    func addMessages(message: String, user: String, idUser: String, dateMessage: String) {
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("msg").addDocument(data: ["msg": message, "user": user, "idUser": idUser, "dateMsg": dateMessage]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("success")
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
    var dateMessage: String
}
