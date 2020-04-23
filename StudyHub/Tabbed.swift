//
//  Tabbed.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

struct Tabbed: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var notificationStore: NotificationStore = NotificationStore.shared
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            CardList()
                .tabItem {
                    Image(systemName: "doc.richtext")
                        .imageScale(.large)
                    Text("Сегодня")
                }.tag(0)
            ScheduleList()
                .tabItem {
                    Image(systemName: "calendar")
                        .imageScale(.large)
                    Text("Расписание")
                }.tag(1)
            NoteView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                    Text("Заметки")
                }.tag(2)
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left")
                        .imageScale(.large)
                    Text("Сообщения")
                }.tag(3)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                    Text("Профиль")
                }.tag(4)
        }
        .banner(isPresented: $sessionStore.showBanner)
        .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
        .onAppear(perform: notificationStore.updateFcmToken)
    }
}

struct Tabbed_Previews: PreviewProvider {
    static var previews: some View {
        Tabbed()
    }
}
