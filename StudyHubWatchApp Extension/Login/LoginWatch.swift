//
//  LoginWatch.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 14.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct AppleLogin: View {
    var body: some View {
        ScrollView {
            Image("defaultlogo")
                .resizable()
                .frame(width: 80, height: 80)
            SignInWithAppleButton()
            NavigationLink(destination: EmailLogin()) {
                Text("Вход через эл.почту")
            }
        }.navigationBarTitle("StudyHub")
    }
}

struct EmailLogin: View {
    @ObservedObject private var sessionStoreWatch = SessionStoreWatch.shared

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ScrollView {
            TextField("Логин", text: $email)
                .textContentType(.emailAddress)
            SecureField("Пароль", text: $password)
                .textContentType(.password)
            Button("Войти") {
                sessionStoreWatch.signInSuccess = true
            }.disabled(email.isEmpty || password.isEmpty)
            Text("Для регистрации воспользуйтесь приложением для iPhone, iPad или Mac.")
                .font(.footnote)
        }.navigationBarTitle("Вход")
    }
}

struct RootView: View {
    @ObservedObject private var sessionStoreWatch = SessionStoreWatch.shared

    var body: some View {
        Group {
            if sessionStoreWatch.signInSuccess {
                MenuWatch()
            } else {
                AppleLogin()
            }
        }
    }
}
