//
//  NotificationSetting.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 03.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NotificationSetting: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var notificationStore: NotificationStore = NotificationStore.shared
    
    @State private var notificationLesson: Bool = true
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL)
            else {
                return
        }
        UIApplication.shared.open(settingsURL)
    }
    
    var footerNotification: Text {
        switch notificationStore.enabled {
        case .denied:
            return Text("Чтобы активировать уведомления нажмите на кнопку \"Включить уведомления\", после чего активируйте уведомления в настройках.")
        case .notDetermined:
            return Text("Чтобы активировать уведомления нажмите на кнопку \"Включить уведомления\".")
        default:
            return Text("")
        }
    }
    
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
            if notificationStore.enabled == .authorized {
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
            Section(header: Text("Активация уведомлений").fontWeight(.bold), footer: footerNotification) {
                if notificationStore.enabled == .authorized {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Button("Выключить уведомления") {
                            self.openSettings()
                        }.foregroundColor(.primary)
                    }
                }
                if notificationStore.enabled == .notDetermined {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Button("Включить уведомления") {
                            self.notificationStore.requestPermission()
                        }.foregroundColor(.primary)
                    }
                }
                if notificationStore.enabled == .denied {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Button("Включить уведомления") {
                            self.openSettings()
                        }.foregroundColor(.primary)
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Уведомления", displayMode: .inline)
    }
}
