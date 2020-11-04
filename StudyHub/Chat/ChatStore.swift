//
//  ChatStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 29.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Alamofire
import Combine
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class ChatStore: ObservableObject {
    @Published var dataMessages = [DataMessages]()
    @Published var dataChat = [DataChat]()
    @Published var statusChat: StatusChat = .loading

    static let shared = ChatStore()

    var isNotRead: Int = 0

    let legacyServerKey: String = "AIzaSyCsYkJqBBzCEVPIRuN4mi0eRr5-x5x-HLs"

    func getDataFromDatabaseListenChat() {
        statusChat = .loading
        let db = Firestore.firestore()
        db.collection("chatRoom").addSnapshotListener { querySnapshot, _ in
            if querySnapshot?.count != 0 {
                let result = Result {
                    try querySnapshot?.documents.compactMap { document -> DataChat? in
                        try document.data(as: DataChat.self)
                    }
                }
                switch result {
                case let .success(dataChat):
                    if let dataChat = dataChat {
                        self.dataChat = dataChat
                        self.statusChat = .showChat
                    } else {
                        self.statusChat = .emptyChat
                    }
                case let .failure(error):
                    self.statusChat = .emptyChat
                    print("Error decoding DataChat: \(error)")
                }
            } else {
                self.statusChat = .emptyChat
            }
        }
    }

    func loadMessageList(id: String) {
        let db = Firestore.firestore()
        db.collection("chatRoom").document(id).collection("messages").order(by: "dateMsg", descending: false).addSnapshotListener { querySnapshot, _ in
            let result = Result {
                try querySnapshot?.documents.compactMap { document -> DataMessages? in
                    try document.data(as: DataMessages.self)
                }
            }
            switch result {
            case let .success(dataMessages):
                if let dataMessages = dataMessages {
                    self.dataMessages = dataMessages
                } else {
                    print("Document does not exist")
                }
            case let .failure(error):
                print("Error decoding DataMessages: \(error)")
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
            "isRead": false,
        ]) { err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
        }
    }

    func updateData(id: String, isRead: Bool) {
        let db = Firestore.firestore()
        db.collection("chatRoom").document("Test2").collection("messages").document(id).updateData(["isRead": isRead]) { err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                print("Сообщения прочитаны!")
            }
        }
    }

    func sendMessage(chatStore _: ChatStore, token: String, title: String, body: String) {
        let currentUser = Auth.auth().currentUser
        addMessageDB(message: body, user: title, idUser: currentUser!.uid)
        isNotRead += 1

        let parameters: Parameters = [
            "to": token,
            "priority": "high",
            "notification": [
                "title": title,
                "body": body,
                "sound": "default",
                "badge": isNotRead,
            ],
            "data": [
                "user": "test_id",
            ],
        ]

        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization("key=\(legacyServerKey)"),
        ]

        let encoding = JSONEncoding.prettyPrinted

        AF.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { response in
                print(response)
            }
    }

    func checkRead() {
        let currentUser = Auth.auth().currentUser
        UIApplication.shared.applicationIconBadgeNumber = 0
        for data in dataMessages {
            if currentUser!.uid != data.idUser, !data.isRead {
                updateData(id: data.id!, isRead: true)
            }
        }
    }
}

struct DataMessages: Identifiable, Codable {
    @DocumentID var id: String?
    var user: String
    var message: String
    var idUser: String
    var dateMsg: Date
    var isRead: Bool = false
}

struct DataChat: Identifiable, Codable {
    @DocumentID var id: String?
    var nameChat: String
    var lastMessage: String
    var lastMessageDate: Date
    var lastMessageIdUser: String
}

enum StatusChat {
    case loading, emptyChat, showChat
}
