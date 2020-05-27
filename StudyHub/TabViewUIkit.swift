//
//  TabViewUIkit.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 27.05.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct TabViewUIkit: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var notificationStore: NotificationStore = NotificationStore.shared
    
    var body: some View {
        UIKitTabView {
            CardList()
                .tab(title: "Сегодня", image: "doc.richtext")
            ScheduleView()
                .tab(title: "Расписание", image: "calendar")
            NoteView()
                .tab(title: "Заметки", image: "square.and.pencil")
            ChatView()
                .tab(title: "Сообщения", image: "bubble.left")
            ProfileView()
                .tab(title: "Профиль", image: "person.crop.circle")
        }
        .banner(isPresented: $sessionStore.showBanner)
        .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
        .onAppear(perform: notificationStore.updateFcmToken)
    }
}
