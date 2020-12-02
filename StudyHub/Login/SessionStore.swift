//
//  SessionStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase
import FirebaseFirestoreSwift
import Purchases
import SwiftUI

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
        listenSession()
    }

    deinit {
        unbind()
    }

    func listenSession() {
        handle = Auth.auth().addStateDidChangeListener { [self] _, responseUser in
            if let currentUser = responseUser {
                user = currentUser
                getDataFromDatabaseListen()
                Purchases.shared.identify(currentUser.uid) { _, error in
                    if let error = error {
                        print("Ошибка Purchases: \(error.localizedDescription)")
                    } else {
                        updateOnlineUser(true)
                    }
                }
                if let providerData = Auth.auth().currentUser?.providerData {
                    for userInfo in providerData {
                        switch userInfo.providerID {
                        case "password":
                            userTypeAuth = .email
                        case "apple.com":
                            userTypeAuth = .appleid
                        default:
                            print("Вход через \(userInfo.providerID)")
                            userTypeAuth = .unknown
                        }
                    }
                }
            } else {
                Purchases.shared.reset { _, _ in
                    print("Пользователь вышел!")
                }
                updateOnlineUser(false)
                user = nil
            }
        }
    }

    func updateOnlineUser(_ onlineUser: Bool) {
        let currentUser = Auth.auth().currentUser
        let db = Firestore.firestore()
        if currentUser != nil {
            let docRef = db.collection("profile").document(currentUser!.uid)
            docRef.updateData([
                "onlineUser": onlineUser,
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

    func getDataFromDatabaseListen() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("profile").document(currentUser.uid).addSnapshotListener { documentSnapshot, error in
            let result = Result {
                try documentSnapshot?.data(as: UserData.self)
            }
            switch result {
            case let .success(userData):
                if let userData = userData {
                    self.userData = userData
                } else {
                    print("Document does not exist")
                }
            case let .failure(error):
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
        Auth.auth().currentUser?.sendEmailVerification { _ in }
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
    var choiseGroup: Int
    var choiseFaculty: Int {
        didSet {
            if !PickerStore.shared.facultyModel.isEmpty {
                PickerStore.shared.loadPickerGroup()
            }
        }
    }
    var darkThemeOverride: Bool
}

enum ActiveAuthType {
    case appleid, email, unknown
}
