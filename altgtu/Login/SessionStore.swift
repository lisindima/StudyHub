//
//  SessionStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Foundation
import Firebase
import Combine
import AuthenticationServices
import CryptoKit
import UnsplashPhotoPicker
import Kingfisher
import Instabug

struct User {
    
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}

class SessionStore: NSObject, ObservableObject {
    
    @Published var session: User?
    @Published var lastname: String!
    @Published var firstname: String!
    @Published var dateBirthDay: Date!
    @Published var email: String!
    @Published var urlImageProfile: String!
    @Published var notifyMinute: Int!
    @Published var choiseNews: Int = 0
    @Published var news: Array = ["Популярное", "Спорт", "Развлечение", "Бизнес", "Здоровье", "Технологии"]
    @Published var imageProfile: UIImage = UIImage()
    @Published var rValue: Double!
    @Published var gValue: Double!
    @Published var bValue: Double!
    @Published var adminSetting: Bool!
    @Published var currentTimeAndDate: String!
    @Published var secureCodeAccess: String!
    @Published var boolCodeAccess: Bool!
    @Published var biometricAccess: Bool!
    @Published var percentComplete: Double = 0.0
    @Published var showBanner: Bool = false
    @Published var userTypeAuth: ActiveAuthType = .email
    @Published var choiseTypeBackroundProfile: Bool!
    @Published var imageFromUnsplashPicker: [UnsplashPhoto] = [UnsplashPhoto]()
    @Published var setImageForBackroundProfile: String!
    @Published var darkThemeOverride: Bool = false {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = darkThemeOverride ? .dark : .unspecified
            settingInstabug()
        }
    }
    
    init(session: User? = nil) {
        self.session = session
    }
    
    enum ActiveAuthType {
        case appleid
        case email
        case unknown
    }
    
    func settingInstabug() {
        if darkThemeOverride {
            Instabug.setColorTheme(.dark)
        } else {
            Instabug.setColorTheme(.light)
        }
        if Auth.auth().currentUser != nil {
            Instabug.identifyUser(withEmail: (Auth.auth().currentUser?.email)!, name: lastname + " " + firstname)
            Instabug.tintColor = UIColor(red: CGFloat(rValue/255), green: CGFloat(gValue/255), blue: CGFloat(bValue/255), alpha: 1)
        }
    }
    
    func currentTime() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm:ss_dd.MM.yyyy"
        self.currentTimeAndDate = formatter.string(from: now)
    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("User: \(user)")
                if let providerData = Auth.auth().currentUser?.providerData {
                    for userInfo in providerData {
                        switch userInfo.providerID {
                        case "password":
                            print("Вход через почту и пароль")
                            self.userTypeAuth = .email
                        case "apple.com":
                            print("Вход через Apple ID")
                            self.userTypeAuth = .appleid
                        default:
                            print("Вход через \(userInfo.providerID)")
                            self.userTypeAuth = .unknown
                        }
                    }
                }
                self.session = User(
                    uid: user.uid,
                    email: user.email
                )
            } else {
                self.session = nil
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
                let dateTimestamp = document.get("dateBirthDay") as? Timestamp
                self.dateBirthDay = dateTimestamp!.dateValue()
                self.email = document.get("email") as? String
                self.urlImageProfile = document.get("urlImageProfile") as? String
                self.notifyMinute = document.get("notifyMinute") as? Int
                self.rValue = document.get("rValue") as? Double
                self.gValue = document.get("gValue") as? Double
                self.bValue = document.get("bValue") as? Double
                self.adminSetting = document.get("adminSetting") as? Bool
                self.darkThemeOverride = document.get("darkThemeOverride") as! Bool
                self.secureCodeAccess = document.get("pinCodeAccess") as? String
                self.boolCodeAccess = document.get("boolCodeAccess") as? Bool
                self.biometricAccess = document.get("biometricAccess") as? Bool
                self.choiseTypeBackroundProfile = document.get("choiseTypeBackroundProfile") as? Bool
                self.setImageForBackroundProfile = document.get("setImageForBackroundProfile") as? String
                self.choiseNews = document.get("choiseNews") as! Int
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
            "email": email!,
            "notifyMinute": notifyMinute!,
            "rValue": rValue!,
            "gValue": gValue!,
            "bValue": bValue!,
            "choiseNews": choiseNews,
            "urlImageProfile": urlImageProfile!,
            "darkThemeOverride": darkThemeOverride,
            "pinCodeAccess": secureCodeAccess!,
            "boolCodeAccess": boolCodeAccess!,
            "biometricAccess": biometricAccess!,
            "setImageForBackroundProfile": setImageForBackroundProfile!,
            "choiseTypeBackroundProfile": choiseTypeBackroundProfile!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Профиль обновлен")
            }
        }
    }
    
    func uploadProfileImageToStorage() {
        let currentUser = Auth.auth().currentUser!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var photoRef = storageRef.child("photoProfile/\(currentUser.uid).jpeg")
        let storagePath = "gs://altgtu-46659.appspot.com/photoProfile/\(currentUser.uid).jpeg"
        photoRef = storage.reference(forURL: storagePath)
        let data = imageProfile.jpegData(compressionQuality: 1)
        if data == nil {
            print("Фото не выбрано")
        } else {
            print("Фото выбрано")
            showBanner = true
            let uploadImageTask = photoRef.putData(data!, metadata: nil) { (metadata, error) in
                photoRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    self.urlImageProfile = downloadURL.absoluteString
                    print("url image: \(String(describing: self.urlImageProfile))")
                    let db = Firestore.firestore()
                    let docRef = db.collection("profile").document(currentUser.uid)
                    docRef.updateData([
                        "urlImageProfile": self.urlImageProfile as Any
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            self.showBanner = false
                        } else {
                            db.collection("profile").document(currentUser.uid)
                                .addSnapshotListener { documentSnapshot, error in
                                    if let document = documentSnapshot {
                                        self.urlImageProfile = document.get("urlImageProfile") as? String
                                        print(self.urlImageProfile ?? "Ошибка, нет Фото!")
                                        self.showBanner = false
                                    } else if error != nil {
                                        print((error?.localizedDescription)!)
                                        self.showBanner = false
                                    }
                            }
                            print("Image successfully updated")
                            self.showBanner = false
                        }
                    }
                }
            }
            uploadImageTask.observe(.progress) { snapshot in
                self.percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                print(self.percentComplete)
            }
        }
    }
    
    func setUnsplashImageForProfileBackground() {
        if imageFromUnsplashPicker.isEmpty {
            print("Обложка не выбрана")
        } else {
            print("Обложка выбрана")
            let selectImage = imageFromUnsplashPicker.first
            let urlsToImage = selectImage?.urls[.regular]
            print(String(describing: urlsToImage))
            setImageForBackroundProfile = urlsToImage?.absoluteString
            choiseTypeBackroundProfile = true
            imageFromUnsplashPicker.removeAll()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    fileprivate var currentNonce: String?
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self as ASAuthorizationControllerDelegate
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
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
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            
        }
    }
}

extension SessionStore: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
            }
        }
    }
}
