//
//  ProfileFriends.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 18.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import KingfisherSwiftUI
import SPAlert
import SwiftUI

struct ProfileFriends: View {
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var qrStore: QRStore = QRStore.shared

    func sendRequestFriend() {
        SPAlert.present(title: "Запрос отправлен!", message: "Запрос на добавления в друзья отправлен.", preset: .done)
    }

    var body: some View {
        VStack {
            if qrStore.profileFriendsModel == nil {
                ProgressView()
            } else {
                HStack {
                    KFImage(URL(string: qrStore.profileFriendsModel.urlImageProfile))
                        .placeholder { ProgressView() }
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
