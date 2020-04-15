//
//  NoteStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 30.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase

class NoteStore: ObservableObject {
    
    @Published var dataNote: [DataNote] = [DataNote]()
    @Published var statusNote: StatusNote = .loading
    
    static let shared = NoteStore()
    
    func getDataFromDatabaseListenNote() {
        statusNote = .loading
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("note").document(currentUser.uid).collection("noteCollection").addSnapshotListener { querySnapshot, error in
            if error != nil {
                self.statusNote = .emptyNote
                print((error?.localizedDescription)!)
                return
            } else if querySnapshot!.isEmpty {
                self.statusNote = .emptyNote
            } else {
                for item in querySnapshot!.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let note = item.document.get("note") as! String
                        self.dataNote.append(DataNote(id: id, note: note))
                        self.statusNote = .showNote
                    }
                }
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
            print("Заметка сохранена")
        }
    }
    
    func deleteNote(datas: NoteStore, index: IndexSet) {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let id = datas.dataNote[index.first!].id
        db.collection("note").document(currentUser.uid).collection("noteCollection").document(id).delete { error in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            } else {
                print("Заметка удалена")
            }
            datas.dataNote.remove(atOffsets: index)
        }
    }
}

struct DataNote: Identifiable, Hashable {
    var id: String
    var note: String
}

enum StatusNote {
    case loading, emptyNote, showNote
}
