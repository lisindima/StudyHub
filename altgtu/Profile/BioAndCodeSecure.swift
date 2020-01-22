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
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var boolCodeAccess: Bool
    @Binding var pinCodeAccess: String
    @Binding var biometricAccess: Bool
    @State private var activateSecure: Bool = false
    @State private var setBoolCodeAccess: Bool = false
    @State private var showAlert: Bool = false
    @State private var setPinCodeAccess: String = ""
    @State private var repeatSetPinCode: String = ""
    
    private let currentBiometricType = BiometricTypeStore.shared.biometricType
    
    private func saveSetPinSetting() {
        boolCodeAccess = setBoolCodeAccess
        pinCodeAccess = setPinCodeAccess
        self.showAlert = true
    }
    
    func checkCurrentBiometricType() {
        switch currentBiometricType {
        case .none:
            print("Устойство не поддерживает TouchID/FaceID")
        case .touchID:
            print("Устойство поддерживает TouchID")
        case .faceID:
            print("Устойство поддерживает FaceID")
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Активация").bold(), footer: Text("После активации этого параметра, в приложение получится войти только после успешного ввода кода или успешной биометрической проверки.")) {
                    Toggle(isOn: $activateSecure.animation()) {
                        Text("Активировать")
                    }
                }
                if activateSecure {
                    Section(header: Text("Стандартная аутентификация").bold(), footer: Text("Здесь активируется возможность использования аутентификации с помощью кода.")) {
                        Toggle(isOn: $setBoolCodeAccess.animation()) {
                            Text("Вход с помощью кода")
                        }
                        if setBoolCodeAccess {
                            SecureField("Пароль", text: $setPinCodeAccess)
                                .disabled(setPinCodeAccess.count > 3)
                                .keyboardType(.numberPad)
                            if setPinCodeAccess != "" {
                                SecureField("Повторите пароль", text: $repeatSetPinCode)
                                    .disabled(repeatSetPinCode.count > 3)
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                }
                if setPinCodeAccess == repeatSetPinCode && setBoolCodeAccess == true && setPinCodeAccess != "" {
                    Section(header: Text("Биометрическая аутентификация").bold(), footer: Text("Здесь активируется возможность использования аутентификации с помощью FaceID или TouchID.")) {
                        if currentBiometricType == .none {
                            Text("Функция не доступна")
                        } else if currentBiometricType == .faceID {
                            Toggle(isOn: $biometricAccess) {
                                Text("Вход с помощью FaceID")
                            }
                        } else if currentBiometricType == .touchID {
                            Toggle(isOn: $biometricAccess) {
                                Text("Вход с помощью FaceID")
                            }
                        }
                    }
                }
                if setPinCodeAccess == repeatSetPinCode && setBoolCodeAccess == true && setPinCodeAccess != "" {
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
        }
        .onAppear(perform: checkCurrentBiometricType)
        .navigationBarTitle(Text("Код-пароль и Face ID"), displayMode: .inline)
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
    
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }
    
    private override init() {}
    
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
