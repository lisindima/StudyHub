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
    
    @Published var noteList: Array = [String]()
    
    func getDataFromDatabaseListenNote() {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser!
        db.collection("note").document(currentUser.uid).collection("noteCollection").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let querySnapshot = querySnapshot {
                self.noteList = querySnapshot.documents.map { $0.documentID }
            }
        }
    }
}
