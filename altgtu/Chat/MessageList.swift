//
//  MessageList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KeyboardObserving
import Firebase

struct MessageList: View {
    
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var message: ChatStore = ChatStore()
    @State private var typeMessage: String = ""
    
    var titleChat: String
    
    let currentUid = Auth.auth().currentUser!.uid
    let receiverFCMToken = "fp-vzEkPzUl_vmFIr7oklo:APA91bEPxtpzxkgLNCqzc_e9jPWv_E9VXiDLedIS4tG6JskSJxR0perifenaN05-uHmlizC3ipsHRzYHjyuYeN7MKogouYl1Scix7SjFgZkJtf_H4tFLVY0F8m3E_m5MwRIbQdojLeOD"
    
    func checkRead() {
        print("Проверка на чтение")
        UIApplication.shared.applicationIconBadgeNumber = 0
        for data in message.messages {
            if self.currentUid != data.idUser && data.isRead == false {
                self.message.updateData(id: data.id, isRead: true)
            }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(message.messages) { item in
                    if self.currentUid == item.idUser {
                        MessageView(message: item.message, sender: item.user, timeMessage: item.dateMessage, isRead: item.isRead)
                            .padding(.top, 6)
                    } else {
                        MessageViewOther(message: item.message, sender: item.user, timeMessage: item.dateMessage)
                            .padding(.top, 6)
                    }
                }
            }
            ChatTextField(sendAction: {_ in
                self.chatStore.sendMessage(datas: self.message, token: self.receiverFCMToken, title: "Лисин", body: self.typeMessage)
                self.typeMessage = ""
            }, messageText: $typeMessage)
        }
        .keyboardObserving()
        .onAppear(perform: checkRead)
        .navigationBarTitle(Text("Лисин Дмитрий"), displayMode: .inline)
        .navigationBarItems(trailing: Button (action: {
            print("plus")
        }) {
            Image(systemName: "info.circle")
                .imageScale(.large)
        })
    }
}

struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        MessageList(titleChat: "test")
    }
}
