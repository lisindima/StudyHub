//
//  SecureView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage
import LocalAuthentication

struct SecureView: View {
    
    @EnvironmentObject var session: SessionStore
    @State private var userInputPin: String = ""
    @State private var showAlertPinCode: Bool = false
    @Binding var access: Bool
    
    let imagePlaceholder = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"

    private func checkAccess() {
        if userInputPin == session.pinCodeAccess {
            self.userInputPin = ""
            self.access = true
        } else {
            self.userInputPin = ""
            self.access = false
            self.showAlertPinCode = true
        }
    }
    
    private func biometricAccess() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.access = true
                        print("все работает")
                    } else {
                        self.access = false
                        print("ошибка")
                    }
                }
            }
        } else {
            print("не настроенно")
        }
    }
    
    private func keyPressed(_ key: String) {
        userInputPin += key
    }
        
    var body: some View {
            VStack(alignment: .center) {
                URLImage(URL(string:"\(session.urlImageProfile ?? imagePlaceholder)")!, incremental : false, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                CircleActivityView().stroke(lineWidth: 15.0)
                            }
                        }
                    }.frame(width: 90, height: 90)
                }) { proxy in
                        proxy.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .clipped()
                            .shadow(radius: 10)
                            .frame(width: 90, height: 90)
                }
                Text("Привет, \(session.firstname ?? "студент")!")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .padding(.top)
                Spacer()
                HStack {
                    Image(systemName: userInputPin.count >= 1 ? "largecircle.fill.circle" : "circle")
                    Image(systemName: userInputPin.count >= 2 ? "largecircle.fill.circle" : "circle")
                    Image(systemName: userInputPin.count >= 3 ? "largecircle.fill.circle" : "circle")
                    Image(systemName: userInputPin.count >= 4 ? "largecircle.fill.circle" : "circle")
                }.foregroundColor(.defaultColorApp)
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
                        Button (action: {
                            self.biometricAccess()
                        })
                        {
                            Image(systemName: "faceid")
                                .foregroundColor(.defaultColorApp)
                                .font(.system(size: 25))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.defaultColorApp, lineWidth: 2)
                                )
                        }
                        KeyPadButton(key: "0")
                            .disabled(userInputPin.count > 3)
                            .padding(.horizontal)
                        Button (action: {
                            self.userInputPin.removeLast()
                        })
                        {
                            Image(systemName: "delete.left")
                                .foregroundColor(.defaultColorApp)
                                .font(.system(size: 25))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.defaultColorApp, lineWidth: 2)
                                )
                        }.disabled(userInputPin.count == 0)
                    }
                }.environment(\.keyPadButtonAction, self.keyPressed(_:))
                CustomButton(
                    label: "Продолжить",
                    action: checkAccess
                ).padding(.top)
                Button (action: {
                    self.session.signOut()
                })
                {
                    Text("Выйти")
                        .bold()
                        .foregroundColor(.red)
                }.padding(.top)
            }
            .padding()
            .onAppear(perform: biometricAccess)
            .alert(isPresented: $showAlertPinCode) {
                Alert(title: Text("Ошибка!"), message: Text("Код неверный."), dismissButton: .default(Text("Ок")))
            }
    }
}
