//
//  AppDelegate.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 15.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Firebase
import Purchases
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PurchasesDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.configure(withAPIKey: "ueKWzICnIniWEbmIuqmyFNJlHBvsQZnf")
        Purchases.shared.delegate = self
        FirebaseApp.configure()
        NotificationStore.shared.requestPermission()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func purchases(_: Purchases, didReceiveUpdated _: Purchases.PurchaserInfo) {
        PurchasesStore.shared.listenPurchases()
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
