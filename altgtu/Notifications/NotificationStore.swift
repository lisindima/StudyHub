//
//  NotificationStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 05.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import UserNotifications

struct Notification {
    var id: String
    var title: String
    var body: String
}

class NotificationStore: ObservableObject {
    
    var notifications = [Notification]()
    
    func setNotification() -> Void {
        let manager = NotificationStore()
        manager.addNotification(title: "Тестовое уведомление", body: "Тест")
        manager.schedule()
    }
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications()
            }
        }
    }
    
    func addNotification(title: String, body: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title, body: body))
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
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
}