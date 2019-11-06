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
    @Published var lastnameProfile: String!
    @Published var firstnameProfile: String!
    @Published var DateTimestamp: Timestamp!
    @Published var DateBirthDay: Date!
    @Published var NotifyAlertProfile: Bool!
    @Published var emailProfile: String!
    @Published var url: String!
    @Published var NotifyMinute: Int!
    @Published var choiseGroup = 0
    @Published var choiseFaculty = 0
    @Published var choiseNews = 0
    @Published var Group = ["БИ-51", "ПИЭ-51", "8ПИЭ-91"]
    @Published var Faculty = ["ФИТ", "ГФ", "ФСТ"]
    @Published var News = ["Бизнес", "Развлечения", "Здоровье", "Наука", "Спорт", "Технологии"]
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
        formatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        self.currentTimeAndDate = formatter.string(from: now)
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
                    self.lastnameProfile = document.get("lastname") as? String
                    self.firstnameProfile = document.get("firstname") as? String
                    self.NotifyAlertProfile = document.get("NotifyAlertProfile") as? Bool
                    self.DateTimestamp = document.get("DateBirthDay") as? Timestamp
                    self.DateBirthDay = self.DateTimestamp.dateValue()
                    self.emailProfile = document.get("email") as? String
                    self.url = document.get("urlImageProfile") as? String
                    self.NotifyMinute = document.get("NotifyMinute") as? Int
                    self.rValue = document.get("rValue") as? Double
                    self.gValue = document.get("gValue") as? Double
                    self.bValue = document.get("bValue") as? Double
                    self.adminSetting = document.get("adminSetting") as? Bool
                    print(self.lastnameProfile ?? "Ошибка, нет Фамилии!")
                    print(self.firstnameProfile ?? "Ошибка, нет Имени!")
                    print(self.NotifyAlertProfile ?? "Ошибка, уведомления!")
                    print(self.DateBirthDay ?? "Ошибка, нет Даты рождения!")
                    print(self.emailProfile ?? "Ошибка, нет Почты!")
                    print(self.url ?? "Ошибка, нет Фото!")
                    print(self.NotifyMinute ?? "Ошибка, нет времени уведомления!")
                    print(self.rValue ?? "Ошибка красный цвет!")
                    print(self.bValue ?? "Ошибка синий цвет!")
                    print(self.gValue ?? "Ошибка зеленый цвет!")
                } else {
                    print("Document does not exist")
                    self.lastnameProfile = "Error"
                    self.firstnameProfile = "Error"
                    self.NotifyAlertProfile = false
                    self.DateBirthDay = Date()
                    self.emailProfile = "test@test.com"
                    self.NotifyMinute = 10
            }
        }
    }
    
    func updateDataFromDatabase() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(currentUser.uid)
            docRef.updateData([
                "lastname": lastnameProfile!,
                "firstname": firstnameProfile!,
                "NotifyAlertProfile": NotifyAlertProfile!,
                "DateBirthDay": DateBirthDay!,
                "email": emailProfile!,
                "NotifyMinute": NotifyMinute!,
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
                self.url = downloadURL.absoluteString
                print("url image: \(String(describing: self.url))")
                let db = Firestore.firestore()
                let docRef = db.collection("profile").document(currentUser.uid)
                    docRef.updateData([
                        "urlImageProfile": self.url as Any
                ]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        db.collection("profile").document(currentUser.uid)
                        .addSnapshotListener { documentSnapshot, error in
                            if let document = documentSnapshot {
                                self.url = document.get("urlImageProfile") as? String
                                print(self.url ?? "Ошибка, нет Фото!")
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
            
            //3
            session.connect(to: tags.first!) { (error: Error?) in
                
                //4
                let myAPDU = NFCISO7816APDU(instructionClass:0, instructionCode:0xB0, p1Parameter:0, p2Parameter:0, data: Data(), expectedResponseLength:16)
                tag.sendCommand(apdu: myAPDU) { (response: Data, sw1: UInt8, sw2: UInt8, error: Error?)
                    in
                    
                    // 5
                    guard error != nil && !(sw1 == 0x90 && sw2 == 0) else {
                        session.invalidate(errorMessage: "Application failure")
                        return
                    }
                }
            }
        }
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
