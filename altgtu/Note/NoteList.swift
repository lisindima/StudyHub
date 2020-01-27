//
//  NoteList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteList: View {
    
    @State private var showAddNewNote: Bool = false
    @State private var showActionSheetSort: Bool = false
    @State private var searchText: String = ""
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private func move(from source: IndexSet, to destination: Int) {
        noteStore.dataNote.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                ZStack {
                    List {
                        ForEach(noteStore.dataNote) { item in
                            NavigationLink(destination: NoteDetails(dataNote: item)) {
                                Text(item.note)
                            }
                        }
                        .onDelete { (index) in
                            self.noteStore.deleteNote(datas: self.noteStore, index: index)
                        }
                        .onMove(perform: move)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showAddNewNote = true
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 60, height: 60)
                                        .shadow(radius: 10)
                                        .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                }
                            }
                        }.padding(20)
                    }
                }
            }
            .sheet(isPresented: $showAddNewNote, onDismiss: {
                
            }, content: {
                NewNote()
                    .environmentObject(NoteStore())
            })
                .actionSheet(isPresented: $showActionSheetSort) {
                    ActionSheet(title: Text("Сортировка"), message: Text("По какому параметру вы хотите отсортировать этот список?"), buttons: [.default(Text("По названию")) {
                        
                        }, .default(Text("По дате создания")) {
                            
                        }, .cancel()])
            }
            .navigationBarTitle(Text("Заметки"))
            .navigationBarItems(leading: EditButton(), trailing: Button (action: {
                self.showActionSheetSort = true
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .imageScale(.large)
            })
        }
    }
}

struct NoteList_Previews: PreviewProvider {
    static var previews: some View {
        NoteList()
    }
}
