//
//  MessageView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Firebase

struct MessageView: View {
    
    var message: String
    var sender: String
    var timeMessage: String
    var isRead: Bool
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.accentColor)
                    .opacity(isRead == true ? 0.0 : 0.5)
                    .padding(.top, 23)
                VStack(alignment: .trailing) {
                    Text(message)
                        .padding(.all, 10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .font(.body)
                        .cornerRadius(5)
                }
            }.padding(.bottom, -3)
            HStack {
                Spacer()
                Text(timeMessage)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }.padding(.trailing, 3)
        }
        .padding(.trailing)
        .padding(.leading, 30)
    }
}

struct MessageViewOther: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var message: String
    var sender: String
    var timeMessage: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: sessionStore.urlImageProfile))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .clipped()
                    .frame(width: 50, height: 50)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(message)
                                .padding(.all, 10)
                                .background(Color(UIColor.secondarySystemBackground))
                                .font(.body)
                                .cornerRadius(5)
                        }.padding(.bottom, 3)
                        Spacer()
                    }
                    HStack {
                        Text(timeMessage)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Spacer()
                    }.padding(.leading, 3)
                }
            }
        }
        .padding(.leading)
        .padding(.trailing, 30)
    }
}
