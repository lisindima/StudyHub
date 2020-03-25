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
    @State private var userInputCode: String = ""
    @State private var changeColor: Bool = false
    @Binding var access: Bool
    
    private let currentBiometricType = BiometricTypeStore.shared.biometricType
    
    private func checkAccess() {
        if userInputCode == sessionStore.secureCodeAccess && userInputCode.count == 4 {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.userInputCode = ""
                self.access = true
            }
        } else if userInputCode != sessionStore.secureCodeAccess && userInputCode.count == 4 {
            self.changeColor = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.userInputCode = ""
                self.access = false
                self.changeColor = false
            }
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
        userInputCode += key
    }
    
    var body: some View {
        VStack(alignment: .center) {
            KFImage(URL(string: sessionStore.urlImageProfile)!)
                .placeholder { ActivityIndicator(styleSpinner: .medium) }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .frame(width: 100, height: 100)
            Text("Привет, \(sessionStore.firstname ?? "студент")!")
                .fontWeight(.bold)
                .font(.system(size: 25))
                .padding(.top)
            Spacer()
            HStack {
                Image(systemName: userInputCode.count >= 1 ? "largecircle.fill.circle" : "circle")
                Image(systemName: userInputCode.count >= 2 ? "largecircle.fill.circle" : "circle")
                Image(systemName: userInputCode.count >= 3 ? "largecircle.fill.circle" : "circle")
                Image(systemName: userInputCode.count == 4 ? "largecircle.fill.circle" : "circle")
            }.foregroundColor(changeColor ? .red : Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
            Spacer()
            VStack {
                HStack {
                    KeyPadButton(key: "1")
                    KeyPadButton(key: "2")
                        .padding(.horizontal)
                    KeyPadButton(key: "3")
                }
                .disabled(userInputCode.count > 3)
                .padding(.bottom)
                HStack {
                    KeyPadButton(key: "4")
                    KeyPadButton(key: "5")
                        .padding(.horizontal)
                    KeyPadButton(key: "6")
                }
                .disabled(userInputCode.count > 3)
                .padding(.bottom)
                HStack {
                    KeyPadButton(key: "7")
                    KeyPadButton(key: "8")
                        .padding(.horizontal)
                    KeyPadButton(key: "9")
                }.disabled(userInputCode.count > 3)
                HStack {
                    if currentBiometricType == .none {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 70, height: 70)
                    } else if !sessionStore.biometricAccess {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(width: 70, height: 70)
                    } else if currentBiometricType == .touchID && sessionStore.biometricAccess {
                        Button(action: {
                            self.biometricAccess()
                        }) {
                            Image("touchid30")
                                .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                                .font(.system(size: 25))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue), lineWidth: 2)
                            )
                        }
                    } else if currentBiometricType == .faceID && sessionStore.biometricAccess {
                        Button(action: {
                            self.biometricAccess()
                        }) {
                            Image(systemName: "faceid")
                                .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                                .font(.system(size: 25))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue), lineWidth: 2)
                            )
                        }
                    }
                    KeyPadButton(key: "0")
                        .disabled(userInputCode.count > 3)
                        .padding(.horizontal)
                    Button(action: {
                        self.userInputCode.removeLast()
                    }) {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                            .font(.system(size: 25))
                            .frame(width: 70, height: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue), lineWidth: 2)
                        )
                    }.disabled(userInputCode.count == 0)
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
        .onAppear(perform: sessionStore.biometricAccess ? biometricAccess : noSetBiometricAccess)
        .onReceive(self.userInputCode.publisher.first()) { _ in
            self.checkAccess()
        }
    }
}
