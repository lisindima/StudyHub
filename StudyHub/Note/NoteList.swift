//
//  NoteList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteList: View {
    
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var showAddNewNote: Bool = false
    @State private var showActionSheetSort: Bool = false
    @State private var searchText: String = ""
    @State private var hideNavigationBar: Bool = false
    
    private func move(from source: IndexSet, to destination: Int) {
        noteStore.dataNote.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBar(text: $searchText, editing: $hideNavigationBar)
                    .animation(.interactiveSpring())
                    .padding(.horizontal, 6)
                List {
                    ForEach(noteStore.dataNote.filter {
                        self.searchText.isEmpty ? true : $0.note.localizedStandardContains(self.searchText)
                    }, id: \.id) { item in
                        NavigationLink(destination: NoteDetails(dataNote: item)) {
                            Text(item.note)
                        }
                    }
                    .onMove(perform: move)
                    .onDelete { index in
                        self.noteStore.deleteNote(datas: self.noteStore, index: index)
                    }
                }
                PlusButton(action: {
                    self.showAddNewNote = true
                }, label: "Новая заметка")
                    .padding(12)
            }
            .sheet(isPresented: $showAddNewNote) {
                NewNote(showAddNewNote: self.$showAddNewNote)
                    .environmentObject(self.noteStore)
            }
            .actionSheet(isPresented: $showActionSheetSort) {
                ActionSheet(title: Text("Сортировка"), message: Text("По какому параметру вы хотите отсортировать этот список?"), buttons: [
                .default(Text("По названию")) {
    
                }, .default(Text("По дате создания")) {
                            
                }, .cancel()])
            }
            .navigationBarHidden(hideNavigationBar)
            .navigationBarTitle("Заметки")
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
