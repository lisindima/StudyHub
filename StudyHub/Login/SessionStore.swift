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
import CryptoKit
import Purchases
import Kingfisher
import UnsplashPhotoPicker
import AuthenticationServices

class SessionStore: NSObject, ObservableObject {
    
    @Published var user: User?
    @Published var lastname: String!
    @Published var firstname: String!
    @Published var dateBirthDay: Date!
    @Published var email: String!
    @Published var urlImageProfile: String!
    @Published var notifyMinute: Int!
    @Published var imageProfile: UIImage = UIImage()
    @Published var rValue: Double!
    @Published var gValue: Double!
    @Published var bValue: Double!
    @Published var adminSetting: Bool!
    @Published var secureCodeAccess: String!
    @Published var boolCodeAccess: Bool!
    @Published var biometricAccess: Bool!
    @Published var percentComplete: Double = 0.0
    @Published var showBanner: Bool = false
    @Published var userTypeAuth: ActiveAuthType = .email
    @Published var choiseTypeBackroundProfile: Bool!
    @Published var imageFromUnsplashPicker: [UnsplashPhoto] = [UnsplashPhoto]()
    @Published var setImageForBackroundProfile: String!
    @Published var onlineUser: Bool = false
    @Published var darkThemeOverride: Bool = false {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = darkThemeOverride ? .dark : .unspecified
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    static let shared = SessionStore()
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    init(user: User? = nil) {
        self.user = user
    }
    
    deinit {
        unbind()
    }
    
    enum ActiveAuthType {
        case appleid
        case email
        case unknown
    }
    
    func listenSession() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
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
                self.user = user
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
        if currentUser != nil {
            let docRef = db.collection("profile").document(currentUser!.uid)
            docRef.updateData([
                "onlineUser": onlineUser
            ]) { err in
                if let err = err {
                    print("onlineUser не обновлен: \(err)")
                } else {
                    if onlineUser == true {
                        self.onlineUser = true
                    } else {
                        self.onlineUser = false
                    }
                }
            }
        }
    }
    
    func getDataFromDatabaseListen() {
        db.collection("profile").document(currentUser!.uid).addSnapshotListener { documentSnapshot, error in
            if let document = documentSnapshot {
                self.lastname = document.get("lastname") as? String
                self.firstname = document.get("firstname") as? String
                if let dateTimestamp = document.get("dateBirthDay") as? Timestamp {
                    self.dateBirthDay = dateTimestamp.dateValue()
                }
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
            } else if error != nil {
                print((error?.localizedDescription)!)
            }
        }
    }
    
    func updateDataFromDatabase() {
        let docRef = db.collection("profile").document(currentUser!.uid)
        docRef.updateData([
            "lastname": lastname!,
            "firstname": firstname!,
            "dateBirthDay": dateBirthDay!,
            "email": email!,
            "notifyMinute": notifyMinute!,
            "rValue": rValue!,
            "gValue": gValue!,
            "bValue": bValue!,
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
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var photoRef = storageRef.child("photoProfile/\(currentUser!.uid).jpeg")
        let storagePath = "gs://altgtu-46659.appspot.com/photoProfile/\(currentUser!.uid).jpeg"
        photoRef = storage.reference(forURL: storagePath)
        let data = imageProfile.jpegData(compressionQuality: 1)
        if data == nil {
            return
        } else {
            showBanner = true
            let uploadImageTask = photoRef.putData(data!, metadata: nil) { metadata, error in
                photoRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        return
                    }
                    self.urlImageProfile = downloadURL.absoluteString
                    let docRef = self.db.collection("profile").document(self.currentUser!.uid)
                    docRef.updateData([
                        "urlImageProfile": self.urlImageProfile as String
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            self.showBanner = false
                        } else {
                            self.db.collection("profile").document(self.currentUser!.uid)
                                .addSnapshotListener { documentSnapshot, error in
                                    if let document = documentSnapshot {
                                        self.urlImageProfile = document.get("urlImageProfile") as? String
                                        self.showBanner = false
                                    } else if error != nil {
                                        print((error?.localizedDescription)!)
                                        self.showBanner = false
                                    }
                            }
                            self.showBanner = false
                        }
                    }
                }
            }
            uploadImageTask.observe(.progress) { snapshot in
                self.percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
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
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
            }
        }
    }
}
