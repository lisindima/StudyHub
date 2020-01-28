//
//  Credential.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 06.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

struct DeleteUser: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var textError: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    
    @EnvironmentObject var sessionStore: SessionStore
    
    private func reauthenticateUser() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.loading = true
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { (authResult, error) in
            if error != nil {
                self.loading = false
                self.textError = (error?.localizedDescription)!
                self.showAlert = true
                print(self.textError)
            } else {
                print("User re-authenticated.")
                Auth.auth().currentUser?.delete { error in
                    if error != nil {
                        self.textError = (error?.localizedDescription)!
                        self.showAlert = true
                    } else {
                        self.loading = false
                        self.activeAlert = .second
                        self.showAlert = true
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
                    if password.isEmpty {
                        
                    }
                    if 0 < password.count && password.count < 8 {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                    if 8 <= password.count {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
                .modifier(InputModifier())
                .padding([.horizontal, .top])
            }
            CustomButton(label: loading == true ? "Загрузка" : "Удалить аккаунт", action: reauthenticateUser, loading: loading, colorButton: Color.red)
                .disabled(loading)
                .padding()
            Divider()
            Text("Чтобы удалить аккаунт вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
            Spacer()
        }
        .navigationBarTitle(Text("Удаление аккаунта"), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .first:
                return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Закрыть")))
            case .second:
                return Alert(title: Text("Аккаунт удален!"), message: Text("Мне очень жаль, что вы решили удалить аккаунт в моем приложение, надеюсь вы скоро вернетесь!"), dismissButton: .default(Text("Закрыть")) {
                    print("Удалено")
                    }
                )
            }
        }
        
    }
}

struct ChangeEmail: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var newEmail: String = ""
    @State private var textError: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var changeView: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionStore: SessionStore
    
    private func reauthenticateUser() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.loading = true
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { (authResult, error) in
            if error != nil {
                self.loading = false
                self.textError = (error?.localizedDescription)!
                self.showAlert = true
                print(self.textError)
            } else {
                print("User re-authenticated.")
                self.loading = false
                self.changeView = true
                
            }
        })
    }
    
    private func changeEmail() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.loading = true
        self.sessionStore.updateEmail(email: self.newEmail) { (error) in
            if error != nil {
                self.loading = false
                self.textError = (error?.localizedDescription)!
                self.showAlert = true
            } else {
                self.loading = false
                self.activeAlert = .second
                self.showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if changeView == false {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                            .textContentType(.password)
                        if password.isEmpty {
                            
                        }
                        if 0 < password.count && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if 8 <= password.count {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .modifier(InputModifier())
                    .padding([.horizontal, .top])
                }
                CustomButton(label: loading == true ? "Загрузка" : "Продолжить", action: reauthenticateUser, loading: loading, colorButton: Color.green)
                    .disabled(loading)
                    .padding()
                Divider()
                Text("Чтобы изменить эл.почту вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            } else {
                CustomInput(text: $newEmail, name: "Введите новую эл.почту")
                    .padding([.top, .horizontal])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                CustomButton(label: loading == true ? "Загрузка" : "Изменить эл.почту", action: changeEmail, loading: loading, colorButton: Color.green)
                    .disabled(loading)
                    .padding()
                Divider()
                Text("Чтобы удалить аккаунт вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle(Text("Изменение эл.почты"), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .first:
                return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Закрыть")))
            case .second:
                return Alert(title: Text("Эл.почта изменена!"), message: Text("Вы успешно изменили свою электронную почту."), dismissButton: .default(Text("Закрыть")) {
                    self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
}

struct ChangePassword: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var textError: String = ""
    @State private var newPassword: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var changeView: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionStore: SessionStore
    
    private func reauthenticateUser() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.loading = true
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { (authResult, error) in
            if error != nil {
                self.loading = false
                self.textError = (error?.localizedDescription)!
                self.showAlert = true
                print(self.textError)
            } else {
                print("User re-authenticated.")
                self.loading = false
                self.changeView = true
            }
        })
    }
    
    private func changePassword() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.loading = true
        self.sessionStore.updatePassword(password: self.newPassword) { (error) in
            if error != nil {
                self.loading = false
                self.textError = (error?.localizedDescription)!
                self.showAlert = true
            } else {
                self.loading = false
                self.activeAlert = .second
                self.showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if changeView == false {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                            .textContentType(.password)
                        if password.isEmpty {
                            
                        }
                        if 0 < password.count && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if 8 <= password.count {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .modifier(InputModifier())
                    .padding([.horizontal, .top])
                }
                CustomButton(label: loading == true ? "Загрузка" : "Продолжить", action: reauthenticateUser, loading: loading, colorButton: Color.green)
                    .disabled(loading)
                    .padding()
                Divider()
                Text("Чтобы изменить пароль вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            } else {
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $newPassword)
                            .textContentType(.newPassword)
                        if newPassword.isEmpty {
                            
                        }
                        if 0 < newPassword.count && newPassword.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if 8 <= newPassword.count {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    .modifier(InputModifier())
                    .padding([.horizontal, .top])
                }
                CustomButton(label: loading == true ? "Загрузка" : "Изменить пароль", action: changePassword, loading: loading, colorButton: Color.green)
                    .disabled(loading)
                    .padding()
                Divider()
                Text("Чтобы изменить пароль вам необходимо ввести данные вашего аккаунта, это необходимо для подтверждения вашей личности.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            }
        }
        .navigationBarTitle(Text("Изменение пароля"), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .first:
                return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Закрыть")))
            case .second:
                return Alert(title: Text("Пароль изменен!"), message: Text("Вы успешно изменили свой пароль."), dismissButton: .default(Text("Закрыть")) {
                    self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
}

enum ActiveAlert {
    case first
    case second
}

struct Credential_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUser()
    }
}
