//
//  SecureView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import LocalAuthentication

struct SecureView: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var userInputPin: String = ""
    @State private var showAlertPinCode: Bool = false
    @Binding var access: Bool
    
    private let currentBiometricType = BiometricTypeStore.shared.biometricType
    
    private func checkAccess() {
        if userInputPin == sessionStore.pinCodeAccess && userInputPin.count == 4 {
            self.userInputPin = ""
            self.access = true
        } else if userInputPin != sessionStore.pinCodeAccess && userInputPin.count == 4 {
            self.userInputPin = ""
            self.access = false
            self.showAlertPinCode = true
        } else {
            
        }
    }
    
    private func noSetBiometricAccess() {
        print("В настройках не выбрана биометрическая аутентификация")
    }
    
    private func biometricAccess() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Для защиты данных в приложении!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.access = true
                    } else {
                        self.access = false
                    }
                }
            }
        } else {
            print("Не настроено FaceID или TouchID")
        }
    }
    
    private func keyPressed(_ key: String) {
        userInputPin += key
    }
    
    var body: some View {
        VStack(alignment: .center) {
            KFImage(URL(string: sessionStore.urlImageProfile)!)
                .placeholder {
                    ActivityIndicator(styleSpinner: .medium)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .shadow(radius: 10)
                .frame(width: 90, height: 90)
            Text("Привет, \(sessionStore.firstname ?? "студент")!")
                .fontWeight(.bold)
                .font(.system(size: 25))
                .padding(.top)
            Spacer()
            HStack {
                Image(systemName: userInputPin.count >= 1 ? "largecircle.fill.circle" : "circle")
                Image(systemName: userInputPin.count >= 2 ? "largecircle.fill.circle" : "circle")
                Image(systemName: userInputPin.count >= 3 ? "largecircle.fill.circle" : "circle")
                Image(systemName: userInputPin.count == 4 ? "largecircle.fill.circle" : "circle")
            }.foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
            Spacer()
            VStack {
                HStack {
                    KeyPadButton(key: "1")
                    KeyPadButton(key: "2")
                        .padding(.horizontal)
                    KeyPadButton(key: "3")
                }
                .disabled(userInputPin.count > 3)
                .padding(.bottom)
                HStack {
                    KeyPadButton(key: "4")
                    KeyPadButton(key: "5")
                        .padding(.horizontal)
                    KeyPadButton(key: "6")
                }
                .disabled(userInputPin.count > 3)
                .padding(.bottom)
                HStack {
                    KeyPadButton(key: "7")
                    KeyPadButton(key: "8")
                        .padding(.horizontal)
                    KeyPadButton(key: "9")
                }.disabled(userInputPin.count > 3)
                HStack {
                    if currentBiometricType == .none {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 70, height: 70)
                    } else if sessionStore.biometricAccess == false {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 70, height: 70)
                    } else if currentBiometricType == .touchID && sessionStore.biometricAccess == true {
                        Button(action: {
                            self.biometricAccess()
                        }) {
                            Image("touchid30")
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                                .font(.system(size: 25))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0), lineWidth: 2)
                            )
                        }
                    } else if currentBiometricType == .faceID && sessionStore.biometricAccess == true {
                        Button(action: {
                            self.biometricAccess()
                        }) {
                            Image(systemName: "faceid")
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                                .font(.system(size: 25))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0), lineWidth: 2)
                            )
                        }
                    }
                    KeyPadButton(key: "0")
                        .disabled(userInputPin.count > 3)
                        .padding(.horizontal)
                    Button(action: {
                        self.userInputPin.removeLast()
                    }) {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            .font(.system(size: 25))
                            .frame(width: 70, height: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0), lineWidth: 2)
                        )
                    }.disabled(userInputPin.count == 0)
                }
            }.environment(\.keyPadButtonAction, self.keyPressed(_:))
            Button(action: {
                self.sessionStore.signOut()
            }) {
                Text("Выйти")
                    .bold()
                    .foregroundColor(.red)
            }.padding(.top)
        }
        .padding()
        .onReceive([self.userInputPin].publisher.first()) { (value) in
            print(value)
            self.checkAccess()
        }
        .onAppear(perform: sessionStore.biometricAccess == true ? biometricAccess : noSetBiometricAccess)
        .alert(isPresented: $showAlertPinCode) {
            Alert(title: Text("Ошибка!"), message: Text("Код неверный."), dismissButton: .default(Text("Закрыть")))
        }
    }
}
