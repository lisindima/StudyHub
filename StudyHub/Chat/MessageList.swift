//
//  MessageList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import KeyboardObserving

struct MessageList: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @EnvironmentObject var chatStore: ChatStore
    @State private var typeMessage: String = ""
    
    var dataChat: DataChat
    
    let receiverFCMToken: String = "dCePidi5pUeHksSGvfmcB_:APA91bEjfpCxz5udU_IcI--aHpWoo6nY3KL6m7-gzcqyDn0Ll4838nOOHumZY4bwdXzu8SwTqm7-MGhB7eS9SrNoKcGboyUA5vw9hZpw8vM7Bz3DUGcfBd2rzxbrwkR4W7GET7906sMJ"
    
    var body: some View {
        VStack {
            if chatStore.dataMessages.isEmpty {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear {
                        self.chatStore.loadMessageList(id: self.dataChat.id!)
                }
            } else {
                ScrollView {
                    ForEach(chatStore.dataMessages.reversed(), id: \.id) { item in
                        MessageView(message: item.message, dateMessage: item.dateMsg, idUser: item.idUser, isRead: item.isRead)
                            .padding(.top, 6)
                            .scaleEffect(x: -1.0, y: 1.0)
                            .rotationEffect(.degrees(180))
                    }
                }
                .scaleEffect(x: -1.0, y: 1.0)
                .rotationEffect(.degrees(180))
                ChatTextField(messageText: $typeMessage, action: {
                    self.chatStore.sendMessage(chatStore: self.chatStore, token: self.receiverFCMToken, title: "Лисин Дмитрий", body: self.typeMessage)
                    self.typeMessage = ""
                })
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .keyboardObserving()
        .onAppear(perform: chatStore.checkRead)
        .navigationBarTitle(Text(dataChat.nameChat), displayMode: .inline)
    }
}
