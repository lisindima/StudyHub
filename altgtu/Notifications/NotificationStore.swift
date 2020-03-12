//
//  NotificationStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 05.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import UserNotifications

class NotificationStore: ObservableObject {
    
    @EnvironmentObject var sessionStore: SessionStore
    @Published var enabled: UNAuthorizationStatus = .notDetermined
    @Published var fcmToken: String = Messaging.messaging().fcmToken ?? "Ошибка"
    
    static let shared = NotificationStore()
    var notifications = [Notification]()
    var center: UNUserNotificationCenter = .current()
    
    init() {
        center.getNotificationSettings {
            self.enabled = $0.authorizationStatus
        }
    }
    
    func refreshNotificationStatus() {
        center.getNotificationSettings { setting in
            DispatchQueue.main.async {
                self.enabled = setting.authorizationStatus
            }
        }
    }
    
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self.enabled = .authorized
                } else {
                    self.enabled = .denied
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func setNotification() -> Void {
        let manager = NotificationStore()
        manager.addNotification(title: "Тестовое уведомление", body: "Тест")
        manager.schedule()
    }
    
    func addNotification(title: String, body: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title, body: body))
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(60 * sessionStore.notifyMinute), repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Уведомление создано: \(notification.id)")
            }
        }
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func updateFcmToken() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(currentUser.uid)
        docRef.updateData([
            "fcmToken": fcmToken
        ]) { err in
            if let err = err {
                print("fcmToken не обновлен: \(err)")
            } else {
                print("fcmToken обновлен!")
            }
        }
    }
}

struct Notification {
    var id: String
    var title: String
    var body: String
}
