//
//  DeleteUser.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 06.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Firebase
import SPAlert
import SwiftUI

struct DeleteUser: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loading: Bool = false

    private func reauthenticateUser() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { _, error in
            if error != nil {
                SPAlert.present(title: "Произошла ошибка!", message: error?.localizedDescription, preset: .error)
                loading = false
                email = ""
                password = ""
            } else {
                Auth.auth().currentUser?.delete { error in
                    if error != nil {
                        SPAlert.present(title: "Произошла ошибка!", message: error?.localizedDescription, preset: .error)
                        loading = false
                        email = ""
                        password = ""
                    } else {
                        SPAlert.present(title: "Аккаунт удален!", message: "Мне очень жаль...", preset: .done)
                        loading = false
                        email = ""
                        password = ""
                    }
                }
            }
        })
    }

    var body: some View {
        VStack(alignment: .center) {
            CustomInput(text: $email, name: "Эл.почта")
                .padding([.top, .horizontal])
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            VStack(alignment: .trailing) {
                HStack {
                    SecureField("Пароль", text: $password)
                        .textContentType(.password)
                    if password.isEmpty {}
                    if !password.isEmpty && password.count < 8 {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                    if password.count >= 8 {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
                .modifier(InputModifier())
                .padding([.horizontal, .top])
            }
            CustomButton(label: loading ? "Загрузка" : "Удалить аккаунт", loading: loading, colorButton: .red) {
                reauthenticateUser()
            }
            .disabled(loading)
            .padding()
            Divider()
            Text("Чтобы удалить аккаунт вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
            Spacer()
        }
        .navigationBarTitle("Удаление аккаунта", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ChangeEmail: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var newEmail: String = ""
    @State private var loading: Bool = false
    @State private var changeView: Bool = false

    @EnvironmentObject var sessionStore: SessionStore

    private func reauthenticateUser() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { _, error in
            if error != nil {
                SPAlert.present(title: "Произошла ошибка!", message: error?.localizedDescription, preset: .error)
                loading = false
                email = ""
                password = ""
            } else {
                loading = false
                changeView = true
            }
        })
    }

    private func changeEmail() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        sessionStore.updateEmail(email: newEmail) { error in
            if error != nil {
                SPAlert.present(title: "Произошла ошибка!", message: error?.localizedDescription, preset: .error)
                loading = false
                newEmail = ""
            } else {
                SPAlert.present(title: "Эл.почта изменена!", message: "Вы успешно изменили свою электронную почту.", preset: .done)
                loading = false
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            if !changeView {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                            .textContentType(.password)
                        if password.isEmpty {}
                        if !password.isEmpty && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if password.count >= 8 {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .modifier(InputModifier())
                    .padding([.horizontal, .top])
                }
                CustomButton(label: loading ? "Загрузка" : "Продолжить", loading: loading, colorButton: .green) {
                    reauthenticateUser()
                }
                .disabled(loading)
                .padding()
                Divider()
                Text("Чтобы изменить эл.почту вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            } else {
                CustomInput(text: $newEmail, name: "Введите новую эл.почту")
                    .padding([.top, .horizontal])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                CustomButton(label: loading ? "Загрузка" : "Изменить эл.почту", loading: loading, colorButton: .green) {
                    changeEmail()
                }
                .disabled(loading)
                .padding()
                Divider()
                Text("Чтобы удалить аккаунт вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle("Изменение эл.почты", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ChangePassword: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var newPassword: String = ""
    @State private var loading: Bool = false
    @State private var changeView: Bool = false

    @EnvironmentObject var sessionStore: SessionStore

    private func reauthenticateUser() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { _, error in
            if error != nil {
                SPAlert.present(title: "Произошла ошибка!", message: error?.localizedDescription, preset: .error)
                loading = false
                password = ""
                email = ""
            } else {
                loading = false
                changeView = true
            }
        })
    }

    private func changePassword() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        sessionStore.updatePassword(password: newPassword) { error in
            if error != nil {
                SPAlert.present(title: "Произошла ошибка!", message: error?.localizedDescription, preset: .error)
                loading = false
                newPassword = ""
            } else {
                SPAlert.present(title: "Пароль изменен!", message: "Вы успешно изменили свой пароль.", preset: .done)
                loading = false
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            if !changeView {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                            .textContentType(.password)
                        if password.isEmpty {}
                        if !password.isEmpty && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if password.count >= 8 {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .modifier(InputModifier())
                    .padding([.horizontal, .top])
                }
                CustomButton(label: loading ? "Загрузка" : "Продолжить", loading: loading, colorButton: .green) {
                    reauthenticateUser()
                }
                .disabled(loading)
                .padding()
                Divider()
                Text("Чтобы изменить пароль вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            } else {
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $newPassword)
                            .textContentType(.newPassword)
                        if newPassword.isEmpty {}
                        if !newPassword.isEmpty && newPassword.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if newPassword.count >= 8 {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .modifier(InputModifier())
                    .padding([.horizontal, .top])
                }
                CustomButton(label: loading ? "Загрузка" : "Изменить пароль", loading: loading, colorButton: .green) {
                    changePassword()
                }
                .disabled(loading)
                .padding()
                Divider()
                Text("Чтобы изменить пароль вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle("Изменение пароля", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
    }
}
