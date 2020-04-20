//
//  ChatList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import KingfisherSwiftUI

struct ChatList: View {
    
    @EnvironmentObject var chatStore: ChatStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var searchText: String = ""
    @State private var showActionSheetSort: Bool = false
    @State private var hideNavigationBar: Bool = false
    @State private var numberUnreadMessages: Int = 0
    
    private func delete(at offsets: IndexSet) {
        chatStore.dataChat.remove(atOffsets: offsets)
    }
    
    func checkNumberUnreadMessages() {
        numberUnreadMessages = chatStore.dataMessages.filter {
            Auth.auth().currentUser?.uid != $0.idUser && !$0.isRead
        }.count
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBar(text: $searchText, editing: $hideNavigationBar)
                    .animation(.interactiveSpring())
                    .padding(.horizontal, 6)
                List {
                    ForEach(self.chatStore.dataChat.filter {
                        self.searchText.isEmpty ? true : $0.nameChat.localizedStandardContains(self.searchText)
                    }, id: \.id) { item in
                        NavigationLink(destination: MessageList(dataChat: item)) {
                            ListItem(numberUnreadMessages: self.$numberUnreadMessages, dataChat: item)
                        }
                    }.onDelete(perform: delete)
                }
                PlusButton(action: {
                    print("Новое сообщение")
                }, label: "Новое сообщение")
                    .padding(12)
            }
            .onAppear(perform: checkNumberUnreadMessages)
            .navigationBarHidden(hideNavigationBar)
            .navigationBarTitle("Сообщения")
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
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var dateStore: DateStore = DateStore.shared
    @State private var showIndicator: Bool = false
    @Binding var numberUnreadMessages: Int
    
    let currentUid = Auth.auth().currentUser?.uid
    
    var dataChat: DataChat
    
    var body: some View {
        HStack {
            ZStack {
                KFImage(URL(string: sessionStore.urlImageProfile))
                    .onSuccess { _ in
                        self.showIndicator = true
                    }
                    .placeholder { ActivityIndicator(styleSpinner: .medium) }
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .clipped()
                if sessionStore.onlineUser && showIndicator {
                    Circle()
                        .foregroundColor(Color.systemBackground)
                        .frame(width: 15, height: 15)
                        .offset(x: 17, y: 17)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 9, height: 9)
                        .foregroundColor(.green)
                        .opacity(0.8)
                        .offset(x: 17, y: 17)
                }
            }
            VStack(alignment: .leading) {
                Text(dataChat.nameChat)
                    .fontWeight(.bold)
                Text(dataChat.lastMessageIdUser == currentUid ? "Вы: \(dataChat.lastMessage)" : "\(dataChat.lastMessage)")
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(dataChat.lastMessageDate.calenderTimeSinceNow())")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Image(systemName: "\(numberUnreadMessages).circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(.accentColor)
                    .opacity(numberUnreadMessages >= 1 ? 1.0 : 0.0)
            }
        }
    }
}
