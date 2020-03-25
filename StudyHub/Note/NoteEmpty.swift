//
//  NoteEmpty.swift
//  altgtu
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
                    LottieView(filename: "14571-search-loading-animation")
                        .frame(width: 200, height: 200)
                    Text("Нет заметок")
                        .font(.headline)
                    Text("Создайте свою первую заметку")
                        .font(.subheadline)
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
            .sheet(isPresented: $showAddNewNote, onDismiss: {
                
            }, content: {
                NewNote()
                    .environmentObject(self.noteStore)
            })
            .navigationBarTitle(Text("Заметки"))
        }
    }
}

struct NoteEmpty_Previews: PreviewProvider {
    static var previews: some View {
        NoteEmpty()
    }
}
