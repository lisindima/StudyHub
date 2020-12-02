//
//  NotificationStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 05.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase
import SwiftUI
import UserNotifications

class NotificationStore: ObservableObject {
    @EnvironmentObject var sessionStore: SessionStore

    @Published var enabled: UNAuthorizationStatus = .notDetermined
    @Published var fcmToken: String?

    static let shared = NotificationStore()

    var notifications = [Notification]()
    var center: UNUserNotificationCenter = .current()

    init() {
        center.getNotificationSettings { [self] in
            enabled = $0.authorizationStatus
        }
    }

    func refreshNotificationStatus() {
        center.getNotificationSettings { setting in
            DispatchQueue.main.async { [self] in
                enabled = setting.authorizationStatus
            }
        }
    }

    func requestPermission() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async { [self] in
                if granted {
                    enabled = .authorized
                } else {
                    enabled = .denied
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    func setNotification() {
        let manager = NotificationStore()
        manager.addNotification(title: "Тестовое уведомление", body: "Тест")
        manager.schedule()
    }

    func addNotification(title: String, body: String) {
        notifications.append(Notification(id: UUID().uuidString, title: title, body: body))
    }

    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(60 * sessionStore.userData.notifyMinute), repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Уведомление создано: \(notification.id)")
            }
        }
    }

    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                requestPermission()
            case .authorized, .provisional:
                scheduleNotifications()
            default:
                break
            }
        }
    }

    func updateFcmToken() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        if let token = fcmToken {
            let docRef = db.collection("profile").document(currentUser.uid)
            docRef.updateData([
                "fcmToken": token,
            ]) { err in
                if let err = err {
                    print("fcmToken не обновлен: \(err)")
                }
            }
        }
    }
}

struct Notification {
    var id: String
    var title: String
    var body: String
}
