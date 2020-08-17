//
//  NoteList.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import NativeSearchBar
import SwiftUI

struct NoteList: View {
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var searchBar: SearchBar = SearchBar.shared

    @State private var showAddNewNote: Bool = false
    @State private var showActionSheetSort: Bool = false

    private func move(from source: IndexSet, to destination: Int) {
        noteStore.dataNote.move(fromOffsets: source, toOffset: destination)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(noteStore.dataNote.filter {
                        searchBar.text.isEmpty || $0.note.localizedStandardContains(searchBar.text)
                    }, id: \.id) { item in
                        NavigationLink(destination: NoteDetails(dataNote: item)) {
                            VStack {
                                Text(item.note)
                                Text("\(item.createdTime)")
                                    .font(.footnote)
                            }
                        }
                    }
                    .onMove(perform: move)
                    .onDelete { index in
                        self.noteStore.deleteNote(datas: self.noteStore, index: index)
                    }
                }.addSearchBar(searchBar)
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
                    .default(Text("По названию")) {}, .default(Text("По дате создания")) {}, .cancel(),
                ])
            }
            .navigationBarTitle("Заметки")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
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
