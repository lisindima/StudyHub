//
//  StudyHub.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 04.11.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import Purchases

@main
struct StudyHub: App {
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var sessionStore = SessionStore.shared
    @StateObject private var chatStore = ChatStore.shared
    @StateObject private var noteStore = NoteStore.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(sessionStore)
                .environmentObject(chatStore)
                .environmentObject(noteStore)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                NotificationStore.shared.refreshNotificationStatus()
                SessionStore.shared.updateOnlineUser(true)
            } else if phase == .background {
                SessionStore.shared.updateOnlineUser(false)
            } else if phase == .inactive {
                SessionStore.shared.updateOnlineUser(false)
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, PurchasesDelegate, MessagingDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.configure(withAPIKey: "ueKWzICnIniWEbmIuqmyFNJlHBvsQZnf")
        Purchases.shared.delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        NotificationStore.shared.requestPermission()
        return true
    }

    func purchases(_: Purchases, didReceiveUpdated _: Purchases.PurchaserInfo) {
        PurchasesStore.shared.listenPurchases()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        NotificationStore.shared.fcmToken = fcmToken
    }
}
