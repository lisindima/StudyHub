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
    
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private func move(from source: IndexSet, to destination: Int) {
        noteStore.dataNote.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 6)
                ZStack {
                    List {
                        ForEach(noteStore.dataNote.filter {
                            self.searchText.isEmpty ? true : $0.note.localizedStandardContains(self.searchText)
                        }, id: \.id) { item in
                            NavigationLink(destination: NoteDetails(dataNote: item)) {
                                Text(item.note)
                            }
                        }
                        .onDelete { (index) in
                            self.noteStore.deleteNote(datas: self.noteStore, index: index)
                        }
                        .onMove(perform: move)
                    }.gesture(DragGesture().onChanged { _ in
                        UIApplication.shared.endEditing(true)
                    })
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
                    .environmentObject(self.noteStore)
            })
            .actionSheet(isPresented: $showActionSheetSort) {
                ActionSheet(title: Text("Сортировка"), message: Text("По какому параметру вы хотите отсортировать этот список?"), buttons: [
                .default(Text("По названию")) {
    
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
