//
//  NoteStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 30.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

final class NoteStore: ObservableObject {
    
    @Published var dataNote: Array = [DataNote]()
    
    func getDataFromDatabaseListenNote() {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser!
        db.collection("note").document(currentUser.uid).collection("noteCollection")
            .addSnapshotListener { (querySnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for item in querySnapshot!.documentChanges {
                if item.type == .added {
                    let id = item.document.documentID
                    let note = item.document.get("note") as! String
                    self.dataNote.append(DataNote(id: id, note: note))
                }
            }
        }
    }
    
    func addNote(note: String) {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser!
        db.collection("note").document(currentUser.uid).collection("noteCollection").addDocument(data: ["note": note]) { (err) in
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
            print("Заметка сохранена")
        }
    }
    
    func deleteNote(datas: NoteStore, index: IndexSet) {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser!
        let id = datas.dataNote[index.first!].id
        db.collection("note").document(currentUser.uid).collection("noteCollection").document(id).delete { (err) in
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

struct DataNote: Identifiable {
    var id: String
    var note: String
}