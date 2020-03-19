//
//  ProfileFriends.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ProfileFriends: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var qrStore: QRStore = QRStore.shared
    
    var body: some View {
        VStack {
            if qrStore.profileFriendsModel.isEmpty {
                ActivityIndicator(styleSpinner: .large)
            } else {
                HStack {
                    KFImage(URL(string: qrStore.profileFriendsModel.first!.urlImageProfile))
                        .placeholder {
                            ActivityIndicator(styleSpinner: .large)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                        .frame(width: 120, height: 120)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(qrStore.profileFriendsModel.first!.lastname)
                            .fontWeight(.bold)
                            .font(.title)
                        Text(qrStore.profileFriendsModel.first!.firstname)
                            .fontWeight(.bold)
                            .font(.title)
                        Button(action: {}) {
                            HStack {
                                Text("В друзья")
                                    .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .imageScale(.large)
                                    .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                            .opacity(0.2))
                        }
                    }
                }
            }
        }
    }
}
