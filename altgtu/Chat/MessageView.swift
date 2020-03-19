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
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var dateStore: DateStore = DateStore.shared
    
    let currentUid = Auth.auth().currentUser!.uid
    
    var message: String
    var dateMessage: Date
    var idUser: String
    var isRead: Bool
    
    var body: some View {
        Group {
            if currentUid == idUser {
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
                                .padding(10)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(5)
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
                VStack(alignment: .leading) {
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
                                Text(message)
                                    .padding(10)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(5)
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
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading)
                .padding(.trailing, 30)
            }
        }
    }
}
