//
//  NoteStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 30.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase
import FirebaseFirestoreSwift

class NoteStore: ObservableObject {
    
    @Published var dataNote: [DataNote] = [DataNote]()
    @Published var statusNote: StatusNote = .loading
    
    static let shared = NoteStore()
    
    func getDataFromDatabaseListenNote() {
        statusNote = .loading
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("note").document(currentUser.uid).collection("noteCollection").addSnapshotListener { querySnapshot, error in
            if !querySnapshot!.isEmpty {
                let result = Result {
                    try querySnapshot?.documents.compactMap {
                        try $0.data(as: DataNote.self)
                    }
                }
                switch result {
                case .success(let dataNote):
                    if let dataNote = dataNote {
                        self.dataNote = dataNote
                        self.statusNote = .showNote
                    } else {
                       self.statusNote = .emptyNote
                    }
                case .failure(let error):
                    self.statusNote = .emptyNote
                    print("Error decoding DataNote: \(error)")
                }
            } else {
                self.statusNote = .emptyNote
            }
        }
    }
    
    func addNote(note: String) {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("note").document(currentUser.uid).collection("noteCollection").addDocument(data: ["note": note]) { error in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
        }
    }
    
    func deleteNote(datas: NoteStore, index: IndexSet) {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let id = datas.dataNote[index.first!].id
        db.collection("note").document(currentUser.uid).collection("noteCollection").document(id!).delete { error in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            datas.dataNote.remove(atOffsets: index)
        }
    }
}

struct DataNote: Identifiable, Codable {
    @DocumentID var id: String?
    var note: String
    @ServerTimestamp var createdTime: Timestamp?
}

enum StatusNote {
    case loading, emptyNote, showNote
}
