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
    
    @Binding var pinCodeAccess: String
    @Binding var biometricAccess: Bool
    @State private var test1: String = ""
    @State private var test2: String = ""
    var currentType = LAContext().biometryType
    
    func test() {
        pinCodeAccess = test1
    }
    
    var body: some View {
        VStack {
            Form {
                SecureField("Пароль", text: $test1)
                    .keyboardType(.numberPad)
                if test1 != "" {
                     SecureField("Повторите пароль", text: $test2)
                        .keyboardType(.numberPad)
                }
                Toggle(isOn: $biometricAccess) {
                    if currentType == .faceID {
                        Text("Вход с помощью FaceID")
                    } else if currentType == .touchID {
                        Text("Вход с помощью TouchID")
                    } else {
                        Text("Не настроенно")
                    }
                }
            }
            if test1 == test2 && test1 != "" {
                Button("Сохранить") {
                    self.test()
                }
            }
        }
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
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}
