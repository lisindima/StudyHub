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
    
    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var chatStore: ChatStore
    
    @State private var typeMessage: String = ""
    
    let receiverFCMToken: String = "eegqgMIFxEWTq6WcUmkDq1:APA91bHLprcGMNQX2m2TQy1TffExKmmzfPSGDjCn-UfvYJ2Mn3qIU1z3toOjTR0TGBcpUF4ULuya6gIp78AM6eV_k2epd3J48-yMe7V1vLGnCHT061WnzgfLaO5zGOf1KdszEInuUB0Q"
    
    var body: some View {
        VStack {
            if chatStore.dataMessages.isEmpty {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear(perform: chatStore.loadMessageList)
            } else {
                ScrollView {
                    ForEach(chatStore.dataMessages.reversed(), id: \.id) { item in
                        MessageView(message: item.message, dateMessage: item.dateMessage, idUser: item.idUser, isRead: item.isRead)
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
        .navigationBarTitle(Text("Лисин Дмитрий"), displayMode: .inline)
    }
}
