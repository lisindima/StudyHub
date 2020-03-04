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
    let receiverFCMToken = "fp-vzEkPzUl_vmFIr7oklo:APA91bEPxtpzxkgLNCqzc_e9jPWv_E9VXiDLedIS4tG6JskSJxR0perifenaN05-uHmlizC3ipsHRzYHjyuYeN7MKogouYl1Scix7SjFgZkJtf_H4tFLVY0F8m3E_m5MwRIbQdojLeOD"
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatStore.dataMessages.reversed()) { item in
                    if self.currentUid == item.idUser {
                        MessageView(message: item.message, timeMessage: item.dateMessage, isRead: item.isRead)
                            .padding(.top, 6)
                            .scaleEffect(x: -1.0, y: 1.0)
                            .rotationEffect(.degrees(180))
                    } else {
                        MessageViewOther(message: item.message, timeMessage: item.dateMessage)
                            .padding(.top, 6)
                            .scaleEffect(x: -1.0, y: 1.0)
                            .rotationEffect(.degrees(180))
                    }
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

struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        MessageList(titleChat: "test")
    }
}
