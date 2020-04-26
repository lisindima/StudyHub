//
//  LoginScreeWatch.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 14.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct EmailLogin: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var signInSuccess: Bool
    
    var body: some View {
        ScrollView {
            Text("StudyHub")
                .multilineTextAlignment(.center)
            TextField("Логин", text: $email)
            TextField("Пароль", text: $password)
            Button("Войти") {
                self.signInSuccess = true
            }
            Text("Для регистрации воспользуйтесь приложением для iPhone, iPad или Mac.")
                .font(.footnote)
        }
    }
}

struct Login: View {
    
    @State private var signInSuccess = false
    
    var body: some View {
        Group {
            if signInSuccess {
                MenuWatch(signInSuccess: $signInSuccess)
            } else {
                EmailLogin(signInSuccess: $signInSuccess)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
