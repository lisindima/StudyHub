//
//  ChatStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

final class ChatStore: ObservableObject {
    
    @Published var chatList: Array = [String]()
    @Published var messages: Array = [DataMessages]()
    
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
        let db = Firestore.firestore()
        db.collection("chatRoom").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let querySnapshot = querySnapshot {
                self.chatList = querySnapshot.documents.map { $0.documentID }
            }
        }
    }
}

struct DataMessages: Identifiable {
    
    var id: String
    var user: String
    var message: String
    var idUser: String
    var dateMessage: String
}
