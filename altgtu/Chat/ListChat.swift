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
    @EnvironmentObject var sessionChat: SessionChat
    @State private var searchText : String = ""
    
    func delete(at offsets: IndexSet) {
        sessionChat.chatList.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        sessionChat.chatList.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        Group {
            if sessionChat.chatList.isEmpty {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                                ActivityIndicator()
                            Spacer()
                        }
                    }
                    .navigationBarTitle(Text("Чат"))
                }
            } else {
                NavigationView {
                    VStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(red: 150.0/255.0, green: 148.0/255.0, blue: 148.0/255.0))
                                    .padding(.leading, 4)
                                TextField("Поиск", text: $searchText)
                            }
                            .padding(8)
                            .background(Color(red: 237.0/255.0, green: 235.0/255.0, blue: 237.0/255.0, opacity: 1.0))
                            .cornerRadius(8)
                            if !self.searchText.isEmpty {
                                Button(action: {
                                    self.searchText = ""
                                }, label: {
                                    Text("Отмена").foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                                })
                            }
                        }.padding(.horizontal)
                        List {
                            ForEach(self.sessionChat.chatList.filter{
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
        .onAppear(perform: sessionChat.getDataFromDatabaseListenChat)
    }
}

struct ListItem: View {
    
    @EnvironmentObject var sessionChat: SessionChat
    
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
