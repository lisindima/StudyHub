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
    
    @EnvironmentObject var session: SessionStore
    
    @State private var selection: Int = 0
    
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
            Note()
                .environmentObject(NoteStore())
                .tabItem {
                    VStack {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                        Text("Заметки")
                    }
                }.tag(2)
            ListChat()
                .tabItem {
                    VStack{
                        Image(systemName: "bubble.left")
                            .imageScale(.large)
                        Text("Чат")
                    }
                }.tag(3)
            ProfileView()
                .environmentObject(PickerAPI())
                .environmentObject(NFCStore())
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                        Text("Профиль")
                    }
                }.tag(4)
        }
        .banner(isPresented: $session.showBanner)
        .accentColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
        .edgesIgnoringSafeArea(.top)
    }
}

struct Tabbed_Previews: PreviewProvider {
    static var previews: some View {
        Tabbed()
    }
}
