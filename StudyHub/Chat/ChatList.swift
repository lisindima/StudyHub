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
        chatStore.chatList.remove(atOffsets: offsets)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        chatStore.chatList.move(fromOffsets: source, toOffset: destination)
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
                    ForEach(self.chatStore.chatList.filter {
                        self.searchText.isEmpty ? true : $0.localizedStandardContains(self.searchText)
                    }, id: \.self) { item in
                        NavigationLink(destination: MessageList()) {
                            ListItem(
                                numberUnreadMessages: self.$numberUnreadMessages,
                                nameChat: item,
                                lastMessageidUser: self.chatStore.dataMessages.last?.idUser ?? "",
                                lastMessage: self.chatStore.dataMessages.last?.message ?? "Нет сообщений",
                                lastMessageDate: self.chatStore.dataMessages.last?.dateMessage ?? Date()
                            )
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                PlusButton(action: {
                    print("Новое сообщение")
                }, label: "Новое сообщение")
                    .padding(12)
            }
            .onAppear(perform: checkNumberUnreadMessages)
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
    
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var dateStore: DateStore = DateStore.shared
    @Binding var numberUnreadMessages: Int
    @State private var lastMessageIsToday: Bool = false
    
    let currentUid = Auth.auth().currentUser?.uid
    
    var nameChat: String
    var lastMessageidUser: String
    var lastMessage: String
    var lastMessageDate: Date
    
    private func chatIsDateInToday() {
        let isToday = Calendar.current.isDateInToday(lastMessageDate)
        lastMessageIsToday = isToday
    }
    
    var body: some View {
        HStack {
            ZStack {
                KFImage(URL(string: sessionStore.urlImageProfile))
                    .placeholder { ActivityIndicator(styleSpinner: .medium) }
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .clipped()
                if sessionStore.onlineUser {
                    Circle()
                        .foregroundColor(colorScheme == .dark ? .black : .white)
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
                Text("Лисин Дмитрий")
                    .bold()
                Text(lastMessageidUser == currentUid ? "Вы: \(lastMessage)" : "\(lastMessage)")
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(lastMessageDate, formatter: lastMessageIsToday ? dateStore.dateHour : dateStore.dateDay)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Image(systemName: "\(numberUnreadMessages).circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(.accentColor)
                    .opacity(numberUnreadMessages >= 1 ? 1.0 : 0.0)
            }
        }.onAppear(perform: chatIsDateInToday)
    }
}
