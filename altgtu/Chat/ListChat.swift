//
//  ListChat.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ListChat: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sessionChat: ChatStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var searchText : String = ""
    
    private func delete(at offsets: IndexSet) {
        sessionChat.chatList.remove(atOffsets: offsets)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        sessionChat.chatList.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        Group {
            if sessionChat.chatList.isEmpty {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                ActivityIndicator()
                                    .onAppear(perform: sessionChat.getDataFromDatabaseListenChat)
                                Text("ЗАГРУЗКА")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }.navigationBarTitle(Text("Чат"))
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
                        List {
                            ForEach(self.sessionChat.chatList.filter {
                                self.searchText.isEmpty ? true : $0.localizedStandardContains(self.searchText)
                            }, id: \.self) { item in
                                NavigationLink(destination: ChatView(sessionChat: self._sessionChat, titleChat: item)) {
                                    ListItem(sessionChat: self._sessionChat, nameChat: item)
                                }
                            }
                            .onDelete(perform: delete)
                            .onMove(perform: move)
                        }
                        .navigationBarTitle(Text("Чат"))
                        .navigationBarItems(leading: EditButton(), trailing: Button (action: {
                            print("plus")
                        })
                        {
                            Image(systemName: "plus.bubble")
                                .imageScale(.large)
                        })
                    }
                }
            }
        }
    }
}

struct ListItem: View {
    
    @EnvironmentObject var sessionChat: ChatStore
    
    var nameChat: String
    var body: some View {
       HStack {
            Image("avatar")
               .resizable()
               .frame(width: 50, height: 50)
               .clipShape(Circle())
               .clipped()
            VStack(alignment: .leading) {
                Text(nameChat)
                    .bold()
                Text("Автор: сообщение")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

extension Color {
    static var lightThemeBackground = Color(red: 237.0/255.0, green: 238.0/255.0, blue: 240.0/255.0, opacity: 1.0)
    static var darkThemeBackground = Color(red: 27.0/255.0, green: 28.0/255.0, blue: 30.0/255.0, opacity: 1.0)
}
