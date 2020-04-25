//
//  SessionStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import Purchases
import FirebaseFirestoreSwift

class SessionStore: ObservableObject {
    
    @Published var user: User?
    @Published var userData: UserData!
    @Published var showBanner: Bool = false
    @Published var onlineUser: Bool = false
    @Published var percentComplete: Double = 0.0
    @Published var userTypeAuth: ActiveAuthType = .email
    
    static let shared = SessionStore()
    var handle: AuthStateDidChangeListenerHandle?
    let currentUser = Auth.auth().currentUser
    
    init() {
        user = currentUser
        listenSession()
    }
    
    deinit {
        unbind()
    }
    
    func listenSession() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.user = user
                self.getDataFromDatabaseListen()
                Purchases.shared.identify(user.uid, { info, error in
                    if let error = error {
                        print("Ошибка Purchases: \(error.localizedDescription)")
                    } else {
                        self.updateOnlineUser(onlineUser: true)
                    }
                })
                if let providerData = Auth.auth().currentUser?.providerData {
                    for userInfo in providerData {
                        switch userInfo.providerID {
                        case "password":
                            self.userTypeAuth = .email
                        case "apple.com":
                            self.userTypeAuth = .appleid
                        default:
                            print("Вход через \(userInfo.providerID)")
                            self.userTypeAuth = .unknown
                        }
                    }
                }
            } else {
                self.updateOnlineUser(onlineUser: false)
                Purchases.shared.reset { info, error in
                    print("Пользователь вышел!")
                }
                self.user = nil
            }
        }
    }
    
    func updateOnlineUser(onlineUser: Bool) {
        let currentUser = Auth.auth().currentUser
        let db = Firestore.firestore()
        if currentUser != nil {
            let docRef = db.collection("profile").document(currentUser!.uid)
            docRef.updateData([
                "onlineUser": onlineUser
            ]) { err in
                if let err = err {
                    print("onlineUser не обновлен: \(err)")
                } else {
                    if onlineUser {
                        self.onlineUser = true
                    } else {
                        self.onlineUser = false
                    }
                }
            }
        }
    }
    // MARK: Пересмотреть flatMap
    func getDataFromDatabaseListen() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("profile").document(currentUser.uid).addSnapshotListener { documentSnapshot, error in
            let result = Result {
                try documentSnapshot.flatMap {
                    try $0.data(as: UserData.self)
                }
            }
            switch result {
            case .success(let userData):
                if let userData = userData {
                    self.userData = userData
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding UserData: \(error)")
            }
        }
    }
    
    func updateDataFromDatabase() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        do {
            try db.collection("profile").document(currentUser.uid).setData(from: userData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error when trying to sign out: \(error.localizedDescription)")
        }
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func sendPasswordReset(email: String, handler: @escaping SendPasswordResetCallback) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
    }
    
    func updateEmail(email: String, handler: @escaping UserProfileChangeCallback) {
        Auth.auth().currentUser?.updateEmail(to: email, completion: handler)
    }
    
    func updatePassword(password: String, handler: @escaping UserProfileChangeCallback) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: handler)
    }
    
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { error in }
    }
}

struct UserData: Identifiable, Codable {
    @DocumentID var id: String?
    var lastname: String
    var firstname: String
    var dateBirthDay: Date
    var urlImageProfile: String
    var notifyMinute: Int
    var rValue: Double
    var gValue: Double
    var bValue: Double
    var adminSetting: Bool
    var pinCodeAccess: String
    var boolCodeAccess: Bool
    var biometricAccess: Bool
    var choiseTypeBackroundProfile: Bool
    var setImageForBackroundProfile: String
    var choiseGroup: Int
    var choiseFaculty: Int {
        didSet {
            if !PickerStore.shared.facultyModel.isEmpty {
                PickerStore.shared.loadPickerGroup()
            }
        }
    }
    var darkThemeOverride: Bool {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = darkThemeOverride ? .dark : .unspecified
        }
    }
}

enum ActiveAuthType {
    case appleid, email, unknown
}
