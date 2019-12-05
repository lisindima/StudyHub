//
//  Session.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Foundation
import Firebase
import Combine
import CoreNFC
import AuthenticationServices
import CryptoKit

struct User {
    
    var uid: String
    var email: String?
    var photoURL: URL?
    var displayName: String?
    
    static let `default` = Self(
        uid: "stockID",
        displayName: "test test",
        email: "test@test.com",
        photoURL: nil
    )
    
    init(uid: String, displayName: String?, email: String?, photoURL: URL?) {
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
    }
}

final class SessionStore: NSObject, ObservableObject, NFCTagReaderSessionDelegate {

    @Published var currentLoginUser = Auth.auth().currentUser
    @Published var isLoggedIn = false
    @Published var session: User?
    @Published var lastname: String!
    @Published var firstname: String!
    @Published var dateBirthDay: Date!
    @Published var notifyAlertProfile: Bool!
    @Published var email: String!
    @Published var urlImageProfile: String!
    @Published var notifyMinute: Int!
    @Published var choiseGroup = 0
    @Published var choiseFaculty = 0
    @Published var choiseNews = 0
    @Published var group = ["БИ-51", "ПИЭ-51", "8ПИЭ-91"]
    @Published var faculty = ["ФИТ", "ГФ", "ФСТ"]
    @Published var news = ["Бизнес", "Развлечения", "Здоровье", "Спорт", "Технологии"]
    @Published var imageProfile = UIImage()
    @Published var rValue: Double!
    @Published var gValue: Double!
    @Published var bValue: Double!
    @Published var adminSetting: Bool!
    @Published var currentTimeAndDate: String!
    
    var handle: AuthStateDidChangeListenerHandle?
        
    init(session: User? = nil) {
        self.session = session
    }
    
    func currentTime() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm:ss_dd.MM.yyyy"
        self.currentTimeAndDate = formatter.string(from: now)
    }
    
    func setNotification() -> Void {
        let manager = LocalNotificationManager()
        manager.addNotification(title: "Тестовое уведомление")
        manager.schedule()
    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("User: \(user)")
                self.isLoggedIn = true
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email,
                    photoURL: user.photoURL
                )
            }
                else
            {
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    
    func getDataFromDatabaseListen() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
            db.collection("profile").document(currentUser.uid)
            .addSnapshotListener { documentSnapshot, error in
                if let document = documentSnapshot {
                    self.lastname = document.get("lastname") as? String
                    self.firstname = document.get("firstname") as? String
                    self.notifyAlertProfile = document.get("notifyAlertProfile") as? Bool
                    let dateTimestamp = document.get("dateBirthDay") as? Timestamp
                    self.dateBirthDay = dateTimestamp!.dateValue()
                    self.email = document.get("email") as? String
                    self.urlImageProfile = document.get("urlImageProfile") as? String
                    self.notifyMinute = document.get("notifyMinute") as? Int
                    self.rValue = document.get("rValue") as? Double
                    self.gValue = document.get("gValue") as? Double
                    self.bValue = document.get("bValue") as? Double
                    self.adminSetting = document.get("adminSetting") as? Bool
                    print(self.lastname ?? "Ошибка, нет Фамилии!")
                    print(self.firstname ?? "Ошибка, нет Имени!")
                    print(self.notifyAlertProfile ?? "Ошибка, уведомления!")
                    print(self.dateBirthDay ?? "Ошибка, нет Даты рождения!")
                    print(self.email ?? "Ошибка, нет Почты!")
                    print(self.urlImageProfile ?? "Ошибка, нет Фото!")
                    print(self.notifyMinute ?? "Ошибка, нет времени уведомления!")
                    print(self.rValue ?? "Ошибка красный цвет!")
                    print(self.bValue ?? "Ошибка синий цвет!")
                    print(self.gValue ?? "Ошибка зеленый цвет!")
                } else {
                    print("Document does not exist")
                    self.lastname = "Error"
                    self.firstname = "Error"
                    self.notifyAlertProfile = false
                    self.dateBirthDay = Date()
                    self.email = "test@test.com"
                    self.notifyMinute = 10
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
                "notifyAlertProfile": notifyAlertProfile!,
                "dateBirthDay": dateBirthDay!,
                "email": email!,
                "notifyMinute": notifyMinute!,
                "rValue": rValue!,
                "gValue": gValue!,
                "bValue": bValue!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func uploadImageToCloudStorage() {
        let currentUser = Auth.auth().currentUser!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var photoRef = storageRef.child("photoProfile/\(currentUser.uid).jpeg")
        let storagePath = "gs://altgtu-46659.appspot.com/photoProfile/\(currentUser.uid).jpeg"
            photoRef = storage.reference(forURL: storagePath)
        let data = imageProfile.jpegData(compressionQuality: 1)
        if data == nil {
            print("упс")
        }else{
            print("ок")
            _ = photoRef.putData(data!, metadata: nil) { (metadata, error) in
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
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        db.collection("profile").document(currentUser.uid)
                        .addSnapshotListener { documentSnapshot, error in
                            if let document = documentSnapshot {
                                self.urlImageProfile = document.get("urlImageProfile") as? String
                                print(self.urlImageProfile ?? "Ошибка, нет Фото!")
                                } else {
                                    print("Image does not exist")
                                }
                            }
                            print("Image successfully updated")
                        }
                    }
                }
            }
        }
    }
    
    var readerSession: NFCTagReaderSession?

    func readCard() {
        readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        readerSession?.alertMessage = "Приложите свой пропуск для сканирования."
        readerSession?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {

    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if case let NFCTag.iso7816(tag) = tags.first! {
            
            session.connect(to: tags.first!) { (error: Error?) in
                
                let myAPDU = NFCISO7816APDU(instructionClass:0, instructionCode:0xB0, p1Parameter:0, p2Parameter:0, data: Data(), expectedResponseLength:16)
                tag.sendCommand(apdu: myAPDU) { (response: Data, sw1: UInt8, sw2: UInt8, error: Error?)
                    in
                    
                    guard error != nil && !(sw1 == 0x90 && sw2 == 0) else {
                        session.invalidate(errorMessage: "Application failure")
                        return
                    }
                }
            }
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
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func sendPasswordReset(
        email: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateEmail(
        email: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().currentUser?.updateEmail(to: email)
    }
    
    func updatePassword(
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().currentUser?.updatePassword(to: password)
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
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
            print(error?.localizedDescription as Any)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }
}
