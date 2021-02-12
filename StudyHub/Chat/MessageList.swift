//
//  MessageList.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 18.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Firebase
import SwiftUI

struct MessageList: View {
    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var chatStore: ChatStore

    @State private var typeMessage: String = ""

    var dataChat: DataChat

    let receiverFCMToken: String = "dCePidi5pUeHksSGvfmcB_:APA91bEjfpCxz5udU_IcI--aHpWoo6nY3KL6m7-gzcqyDn0Ll4838nOOHumZY4bwdXzu8SwTqm7-MGhB7eS9SrNoKcGboyUA5vw9hZpw8vM7Bz3DUGcfBd2rzxbrwkR4W7GET7906sMJ"

    var body: some View {
        VStack {
            if chatStore.dataMessages.isEmpty {
                ProgressView()
                    .onAppear { chatStore.loadMessageList(id: dataChat.id!) }
            } else {
                ScrollView {
                    ForEach(chatStore.dataMessages.reversed(), id: \.id) { item in
                        MessageItem(dataMessages: item)
                            .padding(.top, 6)
                            .scaleEffect(x: -1.0, y: 1.0)
                            .rotationEffect(.degrees(180))
                    }
                }
                .scaleEffect(x: -1.0, y: 1.0)
                .rotationEffect(.degrees(180))
                ChatTextField(messageText: $typeMessage, action: {
                    chatStore.sendMessage(token: receiverFCMToken, title: "Лисин Дмитрий", body: typeMessage)
                    typeMessage = ""
                })
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .onAppear(perform: chatStore.checkRead)
        .navigationBarTitle(Text(dataChat.nameChat), displayMode: .inline)
    }
}
