//
//  ProfileFriends.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import SPAlert
import KingfisherSwiftUI

struct ProfileFriends: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var qrStore: QRStore = QRStore.shared
    
    @Binding var showPartialSheetProfile: Bool
    
    func sendRequestFriend() {
        self.showPartialSheetProfile = false
        SPAlert.present(title: "Запрос отправлен!", message: "Запрос на добавления в друзья отправлен.", preset: .done)
    }
    
    var body: some View {
        VStack {
            if qrStore.profileFriendsModel == nil {
                ActivityIndicator(styleSpinner: .large)
            } else {
                HStack {
                    KFImage(URL(string: qrStore.profileFriendsModel.urlImageProfile))
                        .placeholder { ActivityIndicator(styleSpinner: .large) }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                        .frame(width: 120, height: 120)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(qrStore.profileFriendsModel.lastname)
                            .fontWeight(.bold)
                            .font(.title)
                        Text(qrStore.profileFriendsModel.firstname)
                            .fontWeight(.bold)
                            .font(.title)
                        Button(action: sendRequestFriend) {
                            HStack {
                                Text("В друзья")
                                    .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .imageScale(.large)
                                    .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            .opacity(0.2))
                        }
                    }
                }
            }
        }
    }
}
