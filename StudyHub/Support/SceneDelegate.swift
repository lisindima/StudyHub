//
//  SceneDelegate.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 15.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Firebase
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let sessionStore = SessionStore.shared
    let chatStore = ChatStore.shared
    let noteStore = NoteStore.shared
    let notificationStore = NotificationStore.shared

    private(set) static var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        Self.shared = self

        // Messaging.messaging().delegate = self

        let rootView = RootView()
            .environmentObject(sessionStore)
            .environmentObject(chatStore)
            .environmentObject(noteStore)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(URLContexts)
    }

//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        notificationStore.fcmToken = fcmToken
//    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        SessionStore.shared.updateOnlineUser(onlineUser: false)
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        NotificationStore.shared.refreshNotificationStatus()
        SessionStore.shared.updateOnlineUser(onlineUser: true)
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Save changes in the application's managed object context when the application transitions to the background.
        SessionStore.shared.updateOnlineUser(onlineUser: false)
    }
}
