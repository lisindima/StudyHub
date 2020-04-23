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
    
    @Published var userData: UserData!
    
    @Published var user: User?
    @Published var lastname: String!
    @Published var firstname: String!
    @Published var dateBirthDay: Date!
    @Published var urlImageProfile: String!
    @Published var notifyMinute: Int!
    @Published var rValue: Double!
    @Published var gValue: Double!
    @Published var bValue: Double!
    @Published var adminSetting: Bool!
    @Published var pinCodeAccess: String!
    @Published var boolCodeAccess: Bool!
    @Published var biometricAccess: Bool!
    @Published var choiseTypeBackroundProfile: Bool!
    @Published var setImageForBackroundProfile: String!
    @Published var percentComplete: Double = 0.0
    @Published var userTypeAuth: ActiveAuthType = .email
    @Published var showBanner: Bool = false
    @Published var onlineUser: Bool = false
    @Published var darkThemeOverride: Bool = false {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = darkThemeOverride ? .dark : .unspecified
        }
    }
    
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
    // MARK: Пересмотреть
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
    
    func testFirestore() {
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
    
    func getDataFromDatabaseListen() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("profile").document(currentUser.uid).addSnapshotListener { documentSnapshot, error in
            if let document = documentSnapshot {
                self.lastname = document.get("lastname") as? String
                self.firstname = document.get("firstname") as? String
                if let dateTimestamp = document.get("dateBirthDay") as? Timestamp {
                    self.dateBirthDay = dateTimestamp.dateValue()
                }
                self.urlImageProfile = document.get("urlImageProfile") as? String
                self.notifyMinute = document.get("notifyMinute") as? Int
                self.rValue = document.get("rValue") as? Double
                self.gValue = document.get("gValue") as? Double
                self.bValue = document.get("bValue") as? Double
                self.adminSetting = document.get("adminSetting") as? Bool
                self.darkThemeOverride = document.get("darkThemeOverride") as! Bool
                self.pinCodeAccess = document.get("pinCodeAccess") as? String
                self.boolCodeAccess = document.get("boolCodeAccess") as? Bool
                self.biometricAccess = document.get("biometricAccess") as? Bool
                self.choiseTypeBackroundProfile = document.get("choiseTypeBackroundProfile") as? Bool
                self.setImageForBackroundProfile = document.get("setImageForBackroundProfile") as? String
            } else if error != nil {
                print((error?.localizedDescription)!)
            }
        }
    }
    
    func updateDataFromDatabase() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(currentUser.uid)
        docRef.updateData([
            "lastname": lastname!,
            "firstname": firstname!,
            "dateBirthDay": dateBirthDay!,
            "notifyMinute": notifyMinute!,
            "rValue": rValue!,
            "gValue": gValue!,
            "bValue": bValue!,
            "darkThemeOverride": darkThemeOverride,
            "pinCodeAccess": pinCodeAccess!,
            "boolCodeAccess": boolCodeAccess!,
            "biometricAccess": biometricAccess!,
            "setImageForBackroundProfile": setImageForBackroundProfile!,
            "choiseTypeBackroundProfile": choiseTypeBackroundProfile!
        ]) { err in
            if let err = err {
                print("Ошибка обновления профиля: \(err)")
            }
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
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
        Auth.auth().currentUser?.sendEmailVerification { error in
            
        }
    }
}

struct UserData: Identifiable, Codable {
    @DocumentID var id: String?
    var lastname: String
    var firstname: String
    @ServerTimestamp var dateBirthDay: Timestamp?
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
    var darkThemeOverride: Bool
}

enum ActiveAuthType {
    case appleid, email, unknown
}
