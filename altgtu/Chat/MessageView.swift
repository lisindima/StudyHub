//
//  MessageView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

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
                    .shadow(radius: 5)
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
                        Text("22:30")
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

struct MessageView: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var message: String
    var sender: String
    var timeMessage: String
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message)
                        .padding(.all, 10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .font(.body)
                        .cornerRadius(5)
                }.padding(.bottom, 3)
            }
            HStack {
                Spacer()
                Text("12:35")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }.padding(.trailing, 3)
        }
        .padding(.trailing)
        .padding(.leading, 30)
    }
}
