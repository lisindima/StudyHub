//
//  ChatView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KeyboardObserving
import Firebase

struct ChatView: View {
    
    @EnvironmentObject var sessionChat: SessionChat
    @EnvironmentObject var session: SessionStore
    @ObservedObject var msg = SessionChat()
    @State private var typeMessage: String = ""
    
    let currentUid = Auth.auth().currentUser!.uid
    var titleChat: String
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(msg.msgs) { i in
                    if self.currentUid == i.idUser {
                        MessageView(message: i.msg, sender: i.user, timeMsg: i.dateMsg)
                            .padding(.top, 6)
                            .contextMenu {
                                Button(action:
                                    {
    
                                    }){
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Удалить")
                                }
                            }
                        }
                    }
                    else {
                        MessageView1(message: i.msg, sender: i.user, timeMsg: i.dateMsg)
                            .padding(.top, 6)
                    }
                }
            }
                Spacer()
            HStack {
                CustomInput(text: $typeMessage, name: "Введите сообщение")
                if typeMessage.isEmpty == false {
                    Button(action:{
                        self.session.currentTime()
                        self.sessionChat.addMsg(msg: self.typeMessage, user: "\(self.session.lastnameProfile + " " + self.session.firstnameProfile)", idUser: self.currentUid, dateMsg: self.session.currentTimeAndDate ?? "error")
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
                }.padding([.horizontal, .bottom])
            }
            .keyboardObserving()
            .navigationBarTitle(Text(titleChat), displayMode: .inline)
            .navigationBarItems(trailing: Button (action: {
                    print("plus")
                })
                {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
        })
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(titleChat: "test")
    }
}
