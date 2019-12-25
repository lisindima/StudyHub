//
//  PinSetting.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct PinSetting: View {
    
    @Binding var boolCodeAccess: Bool
    @Binding var pinCodeAccess: String
    @Binding var biometricAccess: Bool
    //@State private var setBoolCodeAccess: Bool = false
    @State private var setPinCodeAccess: String = ""
    @State private var repeatSetPinCode: String = ""
    @State private var setDifficultPinCode: Int = 0

    let currentBiometricType = BiometricTypeStore.shared.biometricType
    
    func saveSetPinSetting() {
        //boolCodeAccess = setBoolCodeAccess
        pinCodeAccess = setPinCodeAccess
    }
    
    func disaapper() {
        print("закрыто")
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
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    Toggle(isOn: $boolCodeAccess.animation()) {
                            Text("ПИН-код")
                    }
                }
                if boolCodeAccess {
                    Section(footer: Text("Здесь вы можете выбрать длину пин-кода.")) {
                        Picker("", selection: $setDifficultPinCode) {
                            Text("4-ех значный").tag(0)
                            Text("8-ми значный").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }
                if boolCodeAccess {
                    Section() {
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
                if currentBiometricType == .none {
                        
                } else {
                    Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    Toggle(isOn: $biometricAccess) {
                            if currentBiometricType == .faceID {
                                Text("Вход с помощью FaceID")
                            } else if currentBiometricType == .touchID {
                                Text("Вход с помощью TouchID")
                            }
                        }
                    }
                }
                if setPinCodeAccess == repeatSetPinCode && setPinCodeAccess != "" {
                    Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
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
        .onDisappear(perform: disaapper)
        .onAppear(perform: checkCurrentBiometricType)
        .navigationBarTitle(Text("Настройка ПИН-кода"), displayMode: .inline)
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
