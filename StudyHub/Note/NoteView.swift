//
//  NoteView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteView: View {
    
    @EnvironmentObject var noteStore: NoteStore
    
    var body: some View {
        Group {
            if noteStore.statusNote == .loading {
                NoteLoading()
                    .onAppear(perform: noteStore.getDataFromDatabaseListenNote)
            } else if noteStore.statusNote == .emptyNote {
                NoteEmpty()
            } else if noteStore.statusNote == .showNote {
                NoteList()
            }
        }
    }
}

struct NewNote: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @EnvironmentObject var noteStore: NoteStore
    @State private var textNote: String = ""
    @Binding var showAddNewNote: Bool
    
    func closeNewNote() {
        if !textNote.isEmpty {
            self.noteStore.addNote(note: self.textNote)
        }
        self.showAddNewNote = false
    }
    
    var body: some View {
        NavigationView {
            TextView(text: $textNote)
                .navigationBarTitle("Новая заметка", displayMode: .inline)
                .navigationBarItems(trailing: Button (action: closeNewNote) {
                    Text("Закрыть")
                        .bold()
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
    }
}

struct NoteDetails: View {
    
    var dataNote: DataNote
    
    var body: some View {
        VStack {
            Text(dataNote.note)
        }
    }
}

struct Note_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
