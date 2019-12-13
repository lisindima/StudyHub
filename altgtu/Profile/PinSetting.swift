//
//  PinSetting.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct PinSetting: View {
    
    @Binding var pinCodeAccess: String
    @Binding var biometricAccess: Bool
    @State var test1: String = ""
    
    var body: some View {
        VStack {
            Form {
                TextField("\(pinCodeAccess)", text: $pinCodeAccess)
                if pinCodeAccess != "" {
                    TextField("\(test1)", text: $test1)
                }
                Toggle(isOn: $biometricAccess) {
                    Text("Вход с помощью FaceID")
                }
            }
            if pinCodeAccess == test1 {
                Button("Сохранить") {
                    
                }
            }
        }
        .navigationBarTitle(Text("Настройка ПИН-кода"), displayMode: .inline)
    }
}
