//
//  ChatList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChatList: View {
    
    @EnvironmentObject var chatStore: ChatStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var searchText: String = ""
    @State private var showActionSheetSort: Bool = false
    
    private func delete(at offsets: IndexSet) {
        chatStore.chatList.remove(atOffsets: offsets)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        chatStore.chatList.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 6)
                ZStack {
                    List {
                        ForEach(self.chatStore.chatList.filter {
                            self.searchText.isEmpty ? true : $0.localizedStandardContains(self.searchText)
                        }, id: \.self) { item in
                            NavigationLink(destination: MessageList(chatStore: self._chatStore, titleChat: item)) {
                                ListItem(chatStore: self._chatStore, nameChat: item)
                            }
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                print("Новое сообщение")
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Новое сообщение")
                                        .font(.system(.body, design: .rounded))
                                        .fontWeight(.semibold)
                                }
                            }
                            Spacer()
                        }.padding()
                    }
                }
                .navigationBarTitle(Text("Сообщения"))
                .actionSheet(isPresented: $showActionSheetSort) {
                    ActionSheet(title: Text("Сортировка"), message: Text("По какому параметру вы хотите отсортировать этот список?"), buttons: [
                        .default(Text("По названию")) {
                            
                        }, .default(Text("По дате создания")) {
                            
                        }, .cancel()])
                }
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

struct ListItem: View {
    
    @EnvironmentObject var chatStore: ChatStore
    
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
