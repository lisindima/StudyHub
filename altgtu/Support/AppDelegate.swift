//
//  AppDelegate.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 15.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Instabug
import Purchases

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, PurchasesDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.configure(withAPIKey: "ueKWzICnIniWEbmIuqmyFNJlHBvsQZnf")
        Purchases.shared.delegate = self
        Purchases.debugLogsEnabled = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Instabug.start(withToken: "ca8e774a198603b2bdd7a94fc7963b16", invocationEvents: [.shake])
        Instabug.trackUserSteps = false
        Instabug.reproStepsMode = .disable
        BugReporting.shouldCaptureViewHierarchy = false
        BugReporting.promptOptionsEnabledReportTypes = [.bug, .feedback]
        Replies.enabled = false
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
