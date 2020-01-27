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
            VStack(alignment: .center) {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Нет заметок")
                                .font(.headline)
                            Text("Создайте свою первую заметку")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                self.showAddNewNote = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Новая заметка")
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                }
                            }
                            Spacer()
                        }.padding()
                    }
                }
            }
            .sheet(isPresented: $showAddNewNote, onDismiss: {
                
            }, content: {
                NewNote()
                    .environmentObject(NoteStore())
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
