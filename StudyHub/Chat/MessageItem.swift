//
//  MessageItem.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 28.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import KingfisherSwiftUI

struct MessageItem: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var dateStore: DateStore = DateStore.shared
    
    let currentUser = Auth.auth().currentUser
    
    var dataMessages: DataMessages
    var isMe: Bool {
        currentUser?.uid == dataMessages.idUser
    }
    
    var body: some View {
        Group {
            if isMe {
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.accentColor)
                            .opacity(dataMessages.isRead ? 0.0 : 0.5)
                            .padding(.top, 23)
                        VStack(alignment: .trailing) {
                            if isEmoji {
                                Text(dataMessages.message)
                                    .font(.system(size: 50))
                            } else {
                                Text(dataMessages.message)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.accentColor)
                                    .cornerRadius(5)
                            }
                        }
                    }.padding(.bottom, -3)
                    HStack {
                        Spacer()
                        Text("\(dataMessages.dateMsg, formatter: dateStore.dateHour)")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }.padding(.trailing, 3)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing)
                .padding(.leading, 30)
            } else {
                HStack {
                    KFImage(URL(string: sessionStore.userData.urlImageProfile))
                        .placeholder { ProgressView() }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                        .frame(width: 37, height: 37)
                    VStack {
                        HStack {
                            if isEmoji {
                                Text(dataMessages.message)
                                    .font(.system(size: 50))
                            } else {
                                Text(dataMessages.message)
                                    .padding(10)
                                    .background(Color.secondarySystemBackground)
                                    .cornerRadius(5)
                            }
                            Spacer()
                        }.padding(.bottom, 3)
                        HStack {
                            Text("\(dataMessages.dateMsg, formatter: dateStore.dateHour)")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            Spacer()
                        }.padding(.leading, 3)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading)
                .padding(.trailing, 30)
            }
        }
    }
}

extension MessageItem {
    var isEmoji: Bool {
        (dataMessages.message.count <= 3) && dataMessages.message.containsOnlyEmoji
    }
}
