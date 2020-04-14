//
//  LoginScreeWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 14.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct AppleLogin: View {
    
    @State private var signInSuccess = false
    
    var body: some View {
        ScrollView {
            SignInWithAppleButton()
            NavigationLink(destination: EmailLogin(signInSuccess: $signInSuccess)) {
                Text("Вход через эл.почту")
            }
        }.navigationBarTitle("StudyHub")
    }
}

struct EmailLogin: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var signInSuccess: Bool
    
    var body: some View {
        ScrollView {
            TextField("Логин", text: $email)
                .textContentType(.emailAddress)
            SecureField("Пароль", text: $password)
                .textContentType(.password)
            Button("Войти") {
                self.signInSuccess = true
            }.disabled(email.isEmpty || password.isEmpty)
            Text("Для регистрации воспользуйтесь приложением для iPhone, iPad или Mac.")
                .font(.footnote)
        }.navigationBarTitle("Вход")
    }
}

struct RootView: View {
    
    @State private var signInSuccess = false
    
    var body: some View {
        Group {
            if signInSuccess {
                MenuWatch(signInSuccess: $signInSuccess)
            } else {
                AppleLogin()
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
