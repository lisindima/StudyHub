//
//  Note.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import FloatingButton

struct Note: View {
    
    @State private var showActionSheetSort: Bool = false
    @State private var searchText: String = ""
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var noteStore: NoteStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let textButtons = (0..<ButtonData.iconAndTextTitles.count).reversed().map { i in
        AnyView(IconAndTextButton(imageName: ButtonData.iconAndTextImageNames[i], buttonText: ButtonData.iconAndTextTitles[i]))
    }
    let mainButton = AnyView(MainButton(imageName: "plus", colorHex: "eb3b5a", sizeButton: 60))
    
    private func delete(at offsets: IndexSet) {
        noteStore.noteList.remove(atOffsets: offsets)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        noteStore.noteList.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        Group {
            if noteStore.noteList.isEmpty {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                ActivityIndicator()
                                    .onAppear(perform: noteStore.getDataFromDatabaseListenNote)
                                Text("ЗАГРУЗКА")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                }
            } else {
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
                                Text("Отмена").foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                                })
                            }
                        }
                            .padding(.horizontal)
                            .animation(.default)
                        ZStack {
                            List {
                                ForEach(noteStore.noteList.filter {
                                    self.searchText.isEmpty ? true : $0.localizedStandardContains(self.searchText)}, id: \.self) { item in
                                    Text(item)
                            }
                                .onDelete(perform: delete)
                                .onMove(perform: move)
                        }
                        VStack {
                            Spacer()
                                .layoutPriority(10)
                            HStack {
                                Spacer()
                                    .layoutPriority(10)
                                FloatingButton(mainButtonView: mainButton, buttons: textButtons)
                                    .straight()
                                    .direction(.top)
                                    .alignment(.right)
                                    .spacing(10)
                                    .initialOpacity(0)
                                }.padding(20)
                            }
                        }
                    }
                    .actionSheet(isPresented: $showActionSheetSort) {
                        ActionSheet(title: Text("Сортировка"), message: Text("По какому параметру вы хотите отсортировать этот список?"), buttons: [.default(Text("По названию")) {
                                    
                        }, .default(Text("По дате создания")) {
                                    
                        }, .cancel()])
                    }
                    .navigationBarTitle(Text("Заметки"))
                    .navigationBarItems(leading: EditButton(), trailing: Button (action: {
                            self.showActionSheetSort = true
                    })
                    {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .imageScale(.large)
                    })
                }
            }
        }
    }
}


struct Note_Previews: PreviewProvider {
    static var previews: some View {
        Note()
    }
}
