//
//  Tabbed.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

struct Tabbed : View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var sessionChat: SessionChat
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
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
            ListChat()
                .tabItem {
                    VStack{
                        Image(systemName: "bubble.left")
                            .imageScale(.large)
                        Text("Чат")
                    }
                }.tag(2)
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                        Text("Профиль")
                    }
                }.tag(3)
        }
        .accentColor(Color(red: 10/255.0, green: 10/255.0, blue: 10/255.0, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
    }
}

struct Tabbed_Previews: PreviewProvider {
    static var previews: some View {
        Tabbed()
    }
}
