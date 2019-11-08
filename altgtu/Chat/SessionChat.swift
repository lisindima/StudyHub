//
//  SessionChat.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

final class SessionChat: ObservableObject {
    
    @Published var chatList = [String]()
    @Published var msgs = [dataMessges]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("msg").order(by: "dateMsg")
            .addSnapshotListener { (querySnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for i in querySnapshot!.documentChanges {
                if i.type == .added {
                    print("yap")
                    let user = i.document.get("user") as! String
                    let msg = i.document.get("msg") as! String
                    let idUser = i.document.get("idUser") as! String
                    let dateMsg = i.document.get("dateMsg") as! String
                    let id = i.document.documentID
                    
                    self.msgs.append(dataMessges(id: id, user: user, msg: msg, idUser: idUser, dateMsg: dateMsg))
                }
            }
        }
    }
    
    func addMsg(msg: String, user: String, idUser: String, dateMsg: String) {
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("msg").addDocument(data: ["msg": msg, "user": user, "idUser": idUser, "dateMsg": dateMsg]) { (err) in
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

struct dataMessges: Identifiable {
    
    var id: String
    var user: String
    var msg: String
    var idUser: String
    var dateMsg: String
}
