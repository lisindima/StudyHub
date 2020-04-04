//
//  NotificationSetting.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 03.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NotificationSetting: View {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    @State private var notificationLesson: Bool = true
    
    var footerNotificationLesson: Text {
        switch notificationLesson {
        case true:
            return Text("Здесь настраивается время отсрочки уведомлений от начала пары.")
        case false:
            return Text("Если вы хотите получать уведомления перед началом пары, активируйте этот параметр.")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Настройки уведомлений о паре").fontWeight(.bold), footer: footerNotificationLesson) {
                Toggle(isOn: $notificationLesson.animation()) {
                    Image(systemName: "person.2")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                    Text("Перед парой")
                }
                if notificationLesson {
                    Stepper(value: $sessionStore.notifyMinute, in: 5...30) {
                        Image(systemName: "timer")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("\(sessionStore.notifyMinute) мин")
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Настройки уведомлений", displayMode: .inline)
    }
}
