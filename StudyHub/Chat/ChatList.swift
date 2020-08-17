//
//  ChatList.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 31.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Firebase
import KingfisherSwiftUI
import NativeSearchBar
import SwiftUI

struct ChatList: View {
    @EnvironmentObject var chatStore: ChatStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var searchBar: SearchBar = SearchBar.shared

    private func delete(at offsets: IndexSet) {
        chatStore.dataChat.remove(atOffsets: offsets)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(self.chatStore.dataChat.filter {
                        searchBar.text.isEmpty || $0.nameChat.localizedStandardContains(searchBar.text)
                    }, id: \.id) { item in
                        NavigationLink(destination: MessageList(dataChat: item)) {
                            ListItem(dataChat: item)
                        }
                    }.onDelete(perform: delete)
                }.addSearchBar(searchBar)
                PlusButton(action: {
                    print("Новое сообщение")
                }, label: "Новое сообщение")
                    .padding(12)
            }
            .navigationBarItems(leading: EditButton())
            .navigationBarTitle("Сообщения")
        }
    }
}

struct ListItem: View {
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var dateStore: DateStore = DateStore.shared

    @State private var showIndicator: Bool = false
    @State private var numberUnreadMessages: Int = 0

    let currentUid = Auth.auth().currentUser?.uid
    var dataChat: DataChat

    private func checkNumberUnreadMessages() {
        numberUnreadMessages = chatStore.dataMessages.filter {
            Auth.auth().currentUser?.uid != $0.idUser && !$0.isRead
        }.count
    }

    var body: some View {
        HStack {
            ZStack {
                KFImage(URL(string: sessionStore.userData.urlImageProfile), isLoaded: $showIndicator)
                    .placeholder { ProgressView() }
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
        }.onAppear(perform: checkNumberUnreadMessages)
    }
}
