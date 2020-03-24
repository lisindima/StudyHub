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
    
    @EnvironmentObject var noteStore: NoteStore
    @State private var textNote: String = ""
    @State private var showPencilView: Bool = false
    
    func addNote() {
        noteStore.addNote(note: textNote)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextView(text: $textNote)
                Button(action: addNote) {
                    Text("Сохранить")
                }
            }
            .sheet(isPresented: $showPencilView) {
                PencilKitCanvas()
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle("Новая заметка", displayMode: .inline)
            .navigationBarItems(trailing: Button (action: {
                self.showPencilView = true
            }) {
                Image(systemName: "pencil.tip.crop.circle.badge.plus")
                    .imageScale(.large)
            })
        }
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
