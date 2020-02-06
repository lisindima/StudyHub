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
    
    let currentUid = Auth.auth().currentUser!.uid
    var titleChat: String
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(message.messages) { item in
                    if self.currentUid == item.idUser {
                        MessageView(message: item.message, sender: item.user, timeMessage: item.dateMessage)
                            .padding(.top, 6)
                    } else {
                        MessageViewOther(message: item.message, sender: item.user, timeMessage: item.dateMessage)
                            .padding(.top, 6)
                    }
                }
            }
            Spacer()
            HStack {
                CustomInput(text: $typeMessage, name: "Введите сообщение")
                if typeMessage.isEmpty == false {
                    Button(action: {
                        self.typeMessage = ""
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .animation(.default)
            .padding([.horizontal, .bottom])
        }
        .keyboardObserving()
        .navigationBarTitle(Text(titleChat), displayMode: .inline)
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
