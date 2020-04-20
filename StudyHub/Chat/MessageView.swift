//
//  MessageView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import KingfisherSwiftUI

struct MessageView: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var dateStore: DateStore = DateStore.shared
    
    let currentUser = Auth.auth().currentUser
    
    var message: String
    var dateMessage: Date
    var idUser: String
    var isRead: Bool
    var isMe: Bool {
        currentUser?.uid == idUser
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
                            .opacity(isRead ? 0.0 : 0.5)
                            .padding(.top, 23)
                        VStack(alignment: .trailing) {
                            if isEmoji {
                                Text(message)
                                    .font(.system(size: 50))
                            } else if isLink {
                                RichLink(url: URL(string: message)!)
                                    .frame(width: 80, height: 200)
                                    .padding(.trailing, 50)
                            } else {
                                Text(message)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.accentColor)
                                    .cornerRadius(5)
                            }
                        }
                    }.padding(.bottom, -3)
                    HStack {
                        Spacer()
                        Text("\(dateMessage, formatter: dateStore.dateHour)")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }.padding(.trailing, 3)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing)
                .padding(.leading, 30)
            } else {
                HStack {
                    KFImage(URL(string: sessionStore.urlImageProfile))
                        .placeholder { ActivityIndicator(styleSpinner: .medium) }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                        .frame(width: 37, height: 37)
                    VStack {
                        HStack {
                            if isEmoji {
                                Text(message)
                                    .font(.system(size: 50))
                            } else if isLink {
                                RichLink(url: URL(string: message)!)
                                    .frame(width: 80, height: 200)
                                    .padding(.leading, 50)
                            } else {
                                Text(message)
                                    .padding(10)
                                    .background(Color.secondarySystemBackground)
                                    .cornerRadius(5)
                            }
                            Spacer()
                        }.padding(.bottom, 3)
                        HStack {
                            Text("\(dateMessage, formatter: dateStore.dateHour)")
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

extension MessageView {
    var isEmoji: Bool {
        (message.count <= 3) && message.containsOnlyEmoji
    }
    
    var isLink: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count)) {
            return match.range.length == message.utf16.count
        } else {
            return false
        }
    }
}
