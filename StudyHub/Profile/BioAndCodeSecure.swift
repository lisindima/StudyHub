//
//  BioAndCodeSecure.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct BioAndCodeSecure: View {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var activateSecure: Bool = false
    @State private var setBoolCodeAccess: Bool = false
    @State private var showAlert: Bool = false
    @State private var setSecureCodeAccess: String = ""
    @State private var repeatSetSecureCode: String = ""
    
    private let currentBiometricType = BiometricTypeStore.shared.biometricType
    
    private func saveSetPinSetting() {
        sessionStore.boolCodeAccess = setBoolCodeAccess
        sessionStore.pinCodeAccess = setSecureCodeAccess
        self.showAlert = true
    }
    
    var body: some View {
        Form {
            Section(header: Text("Активация").fontWeight(.bold), footer: Text("После активации этого параметра, в приложение получится войти только после успешного ввода кода или успешной биометрической проверки.")) {
                Toggle(isOn: $activateSecure.animation()) {
                    Text("Активировать")
                }
            }
            if activateSecure {
                Section(header: Text("Стандартная аутентификация").fontWeight(.bold), footer: Text("Здесь активируется возможность использования аутентификации с помощью кода.")) {
                    Toggle(isOn: $setBoolCodeAccess.animation()) {
                        Text("Вход с помощью кода")
                    }
                    if setBoolCodeAccess {
                        SecureField("Пароль", text: $setSecureCodeAccess)
                            .disabled(setSecureCodeAccess.count > 3)
                            .keyboardType(.numberPad)
                        if setSecureCodeAccess != "" {
                            SecureField("Повторите пароль", text: $repeatSetSecureCode)
                                .disabled(repeatSetSecureCode.count > 3)
                                .keyboardType(.numberPad)
                        }
                    }
                }
            }
            if setSecureCodeAccess == repeatSetSecureCode && setBoolCodeAccess && setSecureCodeAccess != "" {
                Section(header: Text("Биометрическая аутентификация").fontWeight(.bold), footer: Text("Здесь активируется возможность использования аутентификации с помощью FaceID или TouchID.")) {
                    if currentBiometricType == .none {
                        Text("Функция не доступна")
                    } else if currentBiometricType == .faceID {
                        Toggle(isOn: $sessionStore.biometricAccess) {
                            Text("Вход с помощью FaceID")
                        }
                    } else if currentBiometricType == .touchID {
                        Toggle(isOn: $sessionStore.biometricAccess) {
                            Text("Вход с помощью FaceID")
                        }
                    }
                }
            }
            if setSecureCodeAccess == repeatSetSecureCode && setBoolCodeAccess && setSecureCodeAccess != "" {
                Section {
                    HStack {
                        Spacer()
                        Button("Сохранить") {
                            self.saveSetPinSetting()
                        }
                        Spacer()
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Код-пароль и Face ID", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Успешно!"), message: Text("Настройки входа сохранены."), dismissButton: .default(Text("Закрыть")) {
                self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

public class BiometricTypeStore: NSObject {
    
    public static let shared = BiometricTypeStore()
    private let context = LAContext()
    private let reason = "Для проверки, какой тип аутентификации настроен на устройстве!"
    private var error: NSError?
    
    var biometricType: BiometricType {
        guard self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }
}

enum BiometricType: String {
    case none, touchID, faceID
}
