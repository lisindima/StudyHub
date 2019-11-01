//
//  SecurityOption.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 01.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct SecurityOption: View {
    
    @State private var mailLogin = true
    @State private var appleLogin = false
    @State private var faceidSecure = false
    let context = LAContext()
    var body: some View {
        Form {
            if (context.biometryType == .faceID) {
                Section(header: Text("Безопасность").bold(), footer: Text("После активации этого параметра, после каждого входа в приложение будет происходить сканирование c помощью FaceID")) {
                    Toggle(isOn: $faceidSecure) {
                        Image(systemName: "faceid")
                        Text("FaceID")
                    }
                }
            }
            if (context.biometryType == .touchID) {
                Section(header: Text("Безопасность").bold(), footer: Text("После активации этого параметра, после каждого входа в приложение будет происходить сканирование c помощью TouchID")) {
                    Toggle(isOn: $faceidSecure) {
                        Image(systemName: "faceid")
                        Text("TouchID")
                    }
                }
            }
            if (context.biometryType == .none) {
    
            }
            Section(header: Text("Варианты входа").bold(), footer: Text("Здесь вы можете выбрать с помощью каких методов аутентификации вы хотите получить доступ к своему аккаунту.")) {
                Toggle(isOn: $mailLogin) {
                    Image(systemName: "envelope")
                    Text("Вход с помощью почты")
                }
                Toggle(isOn: $appleLogin) {
                    Text("Вход через Apple ID")
                }
            }
            .navigationBarTitle(Text("Безопасность и вход"), displayMode: .inline)
        }
    }
}

struct SecurityOption_Previews: PreviewProvider {
    static var previews: some View {
        SecurityOption()
    }
}
