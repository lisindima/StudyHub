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
    
    @EnvironmentObject var sessionStore: SessionStore
    
    @State private var selection: Int = 0
    
    func startTabView() {
        sessionStore.settingInstabug()
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CardList()
                .tabItem {
                    VStack {
                        Image(systemName: "doc.richtext")
                            .imageScale(.large)
                        Text("Сегодня")
                    }
            }.tag(0)
            LessonList()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                        Text("Расписание")
                    }
            }.tag(1)
            NoteView()
                .tabItem {
                    VStack {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                        Text("Заметки")
                    }
            }.tag(2)
            ChatView()
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left")
                            .imageScale(.large)
                        Text("Сообщения")
                    }
            }.tag(3)
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                        Text("Профиль")
                    }
            }.tag(4)
        }
        .banner(isPresented: $sessionStore.showBanner)
        .onAppear(perform: startTabView)
        .accentColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
    }
}

struct Tabbed_Previews: PreviewProvider {
    static var previews: some View {
        Tabbed()
    }
}
