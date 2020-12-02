//
//  NoteStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 30.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase
import FirebaseFirestoreSwift

class NoteStore: ObservableObject {
    @Published var dataNote = [DataNote]()
    @Published var statusNote: StatusNote = .loading

    static let shared = NoteStore()

    func getDataFromDatabaseListenNote() {
        statusNote = .loading
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("note").document(currentUser.uid).collection("noteCollection").addSnapshotListener { [self] querySnapshot, error in
            if querySnapshot?.isEmpty != true {
                let result = Result {
                    try querySnapshot?.documents.compactMap { document -> DataNote? in
                        try document.data(as: DataNote.self)
                    }
                }
                switch result {
                case let .success(response):
                    if let responseNote = response {
                        dataNote = responseNote
                        statusNote = .showNote
                    } else {
                        statusNote = .emptyNote
                    }
                case let .failure(error):
                    statusNote = .emptyNote
                    print("Error decoding DataNote: \(error)")
                }
            } else {
                statusNote = .emptyNote
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
    var createdTime: Date
}

enum StatusNote {
    case loading, emptyNote, showNote
}
