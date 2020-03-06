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
    
    var titleChat: String
    
    let currentUid = Auth.auth().currentUser!.uid
    let receiverFCMToken = "fcpmytj8KEyKjYg5pYuVQt:APA91bG_Gds1llYdxSAZ2o5revrerR8_QNroPjA-8mfRelx08_PeCQ2xKykmonl_DGVYN3QIN97lvOGCJzSRCSbrL_ORiJ7rf8D-i2ujYw8hMP2TvMJl2xfYSTu_E47pzK20mCqzNH9B"
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatStore.dataMessages.reversed(), id: \.id) { item in
                    MessageView(message: item.message, timeMessage: item.dateMessage, idUser: item.idUser, isRead: item.isRead)
                        .padding(.top, 6)
                        .scaleEffect(x: -1.0, y: 1.0)
                        .rotationEffect(.degrees(180))
                }
            }
            .scaleEffect(x: -1.0, y: 1.0)
            .rotationEffect(.degrees(180))
            ChatTextField(messageText: $typeMessage, action: {
                self.chatStore.sendMessage(datas: self.chatStore, token: self.receiverFCMToken, title: "Лисин", body: self.typeMessage)
                self.typeMessage = ""
            })
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .keyboardObserving()
        .onAppear(perform: chatStore.checkRead)
        .navigationBarTitle(Text("Лисин Дмитрий"), displayMode: .inline)
    }
}
