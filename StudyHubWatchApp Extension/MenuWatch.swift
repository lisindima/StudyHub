//
//  MenuWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 16.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct MenuWatch: View {
    
    @Binding var signInSuccess: Bool
    
    var body: some View {
        VStack {
            NavigationLink(destination: ScheduleListWatch()) {
                Text("Расписание")
            }
            NavigationLink(destination: ScheduleListWatch()) {
                Text("Заметки")
            }
            Divider()
            Button("Выйти") {
                self.signInSuccess = false
            }
        }.navigationBarTitle(Text("Главная"))
    }
}
