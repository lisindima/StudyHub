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
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    func getDataFromDatabaseListenNote() {
        statusNote = .loading
        db.collection("note").document(currentUser!.uid).collection("noteCollection").addSnapshotListener { (querySnapshot, err) in
            if err != nil {
                self.statusNote = .emptyNote
                print((err?.localizedDescription)!)
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
        db.collection("note").document(currentUser!.uid).collection("noteCollection").addDocument(data: ["note": note]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("Заметка сохранена")
        }
    }
    
    func deleteNote(datas: NoteStore, index: IndexSet) {
        let id = datas.dataNote[index.first!].id
        db.collection("note").document(currentUser!.uid).collection("noteCollection").document(id).delete { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            } else {
                print("Заметка удалена")
            }
            datas.dataNote.remove(atOffsets: index)
        }
    }
}

enum StatusNote {
    case loading
    case emptyNote
    case showNote
}

struct DataNote: Identifiable, Hashable {
    var id: String
    var note: String
}
