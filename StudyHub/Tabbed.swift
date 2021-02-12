//
//  Tabbed.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 27.05.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Tabbed: View {
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var notificationStore = NotificationStore.shared
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left")
                        .imageScale(.large)
                    Text("Сообщения")
                }
                .tag(0)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                    Text("Профиль")
                }
                .tag(1)
        }
        .banner(isPresented: $sessionStore.showBanner)
        .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
        .onAppear(perform: notificationStore.updateFcmToken)
    }
}
