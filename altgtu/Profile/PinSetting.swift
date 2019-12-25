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
    @State private var setBoolCodeAccess: Bool = false
    @State private var setPinCodeAccess: String = ""
    @State private var repeatSetPinCode: String = ""
    @State private var setDifficultPinCode: Int = 0
    var currentType = LAContext().biometryType
    
    func saveSetPinSetting() {
        boolCodeAccess = setBoolCodeAccess
        pinCodeAccess = setPinCodeAccess
    }
    
    func disaapper() {
        print("закрыто")
    }
    
    func testtesttest() {
        print("открыто")
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    Toggle(isOn: $setBoolCodeAccess.animation()) {
                            Text("ПИН-код")
                    }
                }
                if setBoolCodeAccess {
                    Section(footer: Text("Здесь вы можете выбрать длину пин-кода.")) {
                        Picker("", selection: $setDifficultPinCode) {
                            Text("4-ех значный").tag(0)
                            Text("8-ми значный").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }
                if setBoolCodeAccess {
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
                if currentType == .none {
                        
                } else {
                    Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    Toggle(isOn: $biometricAccess) {
                            if currentType == .faceID {
                                Text("Вход с помощью FaceID")
                            } else if currentType == .touchID {
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
        .onAppear(perform: testtesttest)
        .navigationBarTitle(Text("Настройка ПИН-кода"), displayMode: .inline)
    }
}

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .none
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .faceID : .none
        }
    }
}
