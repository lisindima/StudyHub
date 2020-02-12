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
    @State private var hideNavigationBar: Bool = false
    @State private var numberUnreadMessages: Int = 0
    
    func checkNumberUnreadMessages() {
        let countFalse = chatStore.messages.filter{ !$0.isRead }.count
        numberUnreadMessages = countFalse
        print(numberUnreadMessages, "непрочитанных сообщений")
    }
    
    private func delete(at offsets: IndexSet) {
        chatStore.chatList.remove(atOffsets: offsets)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        chatStore.chatList.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, editing: $hideNavigationBar)
                    .padding(.horizontal, 6)
                ZStack {
                    List {
                        ForEach(self.chatStore.chatList.filter {
                            self.searchText.isEmpty ? true : $0.localizedStandardContains(self.searchText)
                        }, id: \.self) { item in
                            NavigationLink(destination: MessageList(titleChat: item)) {
                                ListItem(numberUnreadMessages: self.$numberUnreadMessages, nameChat: item)
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
            }
            .onAppear(perform: checkNumberUnreadMessages)
            .animation(.interactiveSpring())
            .navigationBarHidden(hideNavigationBar)
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

struct ListItem: View {
    
    @Binding var numberUnreadMessages: Int
    
    var nameChat: String
    var body: some View {
        HStack {
            Image("altIconApp")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .clipped()
            VStack(alignment: .leading) {
                Text("Лисин Дмитрий")
                    .bold()
                Text("Вы: Привет!")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("23:05")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Image(systemName: "\(numberUnreadMessages).circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(.accentColor)
                    .opacity(numberUnreadMessages >= 1 ? 1.0 : 0.0)
            }.padding(.trailing, 6)
        }
    }
}
