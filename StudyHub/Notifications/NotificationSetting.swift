//
//  NotificationSetting.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 03.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NotificationSetting: View {
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var notificationStore = NotificationStore.shared

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
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Перед парой")
                    }
                    if notificationLesson {
                        Stepper(value: $sessionStore.userData.notifyMinute, in: 5 ... 30) {
                            Image(systemName: "timer")
                                .frame(width: 24)
                                .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            Text("\(sessionStore.userData.notifyMinute) мин")
                        }
                    }
                }
            }
            Section(header: Text("Активация уведомлений").fontWeight(.bold), footer: footerNotification) {
                if notificationStore.enabled == .authorized {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button(action: openSettings) {
                            Text("Выключить уведомления")
                                .foregroundColor(.primary)
                        }
                    }
                }
                if notificationStore.enabled == .notDetermined {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button(action: notificationStore.requestPermission) {
                            Text("Включить уведомления")
                                .foregroundColor(.primary)
                        }
                    }
                }
                if notificationStore.enabled == .denied {
                    HStack {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button(action: openSettings) {
                            Text("Включить уведомления")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Уведомления", displayMode: .inline)
    }
}
