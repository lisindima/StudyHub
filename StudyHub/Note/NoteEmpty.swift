//
//  NoteEmpty.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteEmpty: View {
    
    @EnvironmentObject var noteStore: NoteStore
    @State private var showAddNewNote: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Нет заметок")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("Создайте свою первую заметку")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                VStack {
                    Spacer()
                    HStack {
                        PlusButton(action: {
                            self.showAddNewNote = true
                        }, label: "Новая заметка")
                        Spacer()
                    }.padding(12)
                }
            }
            .navigationBarTitle("Заметки")
            .sheet(isPresented: $showAddNewNote) {
                NewNote(showAddNewNote: self.$showAddNewNote)
                    .environmentObject(self.noteStore)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NoteEmpty_Previews: PreviewProvider {
    static var previews: some View {
        NoteEmpty()
    }
}
