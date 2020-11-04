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
            CardList()
                .tabItem {
                    Image(systemName: "doc.richtext")
                        .imageScale(.large)
                    Text("Сегодня")
                }.tag(0)
            ScheduleView()
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
