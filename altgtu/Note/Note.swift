//
//  Note.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Note: View {
    
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
        Group {
            if noteStore.statusNote == .loading {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                ActivityIndicator(styleSpinner: .large)
                                    .onAppear(perform: noteStore.getDataFromDatabaseListenNote)
                            }
                            Spacer()
                        }
                    }.navigationBarTitle(Text("Заметки"))
                }
            } else if noteStore.statusNote == .emptyNote {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                Text("Нет заметок")
                                    .font(.headline)
                                Text("Создайте свою первую заметку!")
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }.navigationBarTitle(Text("Заметки"))
                }
            } else if noteStore.statusNote == .showNote {
                NavigationView {
                    VStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 1)
                                TextField("Поиск", text: $searchText)
                                    .foregroundColor(.primary)
                            }
                            .padding(6.5)
                            .background(colorScheme == .dark ? Color.darkThemeBackground : Color.lightThemeBackground)
                            .cornerRadius(9)
                            if !self.searchText.isEmpty {
                                Button(action: {
                                    self.searchText = ""
                                }, label: {
                                    Text("Отмена")
                                        .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                                })
                            }
                        }
                        .padding(.horizontal)
                        .animation(.default)
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
    }
}

struct NewNote: View {
    
    @EnvironmentObject var noteStore: NoteStore
    @State private var textNote: String = ""
    
    func addNote() {
        noteStore.addNote(note: textNote)
    }
    
    var body: some View {
        VStack {
            TextField("Заметка", text: $textNote)
            Button(action: addNote) {
                Text("Сохранить")
            }
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
        Note()
    }
}
