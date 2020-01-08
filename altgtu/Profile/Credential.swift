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
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var textError: String = ""

    @EnvironmentObject var session: SessionStore
    
    private func reauthenticateUser() {
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
        NavigationView {
            VStack(alignment: .center) {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                        if password.isEmpty {
                        
                        }
                        if 0 < password.count && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if 8 <= password.count{
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
            .navigationBarTitle(Text("Удаление аккаунта"))
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                    case .first:
                        return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Хорошо")))
                    case .second:
                        return Alert(title: Text("Аккаунт удален!"), message: Text("Мне очень жаль, что вы решили удалить аккаунт в моем приложение, надеюсь вы скоро вернетесь:)"), dismissButton: .default(Text("Выйти")) {
                            //self.session.signOut()
                        }
                    )
                }
            }
        }
    }
}

struct ChangeEmail: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var textError: String = ""

    @EnvironmentObject var session: SessionStore
    
    private func reauthenticateUser() {
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
                self.session.updateEmail(email: self.email) { (error) in
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
        NavigationView {
            VStack(alignment: .center) {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                        if password.isEmpty {
                        
                        }
                        if 0 < password.count && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if 8 <= password.count{
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
            .navigationBarTitle(Text("Удаление аккаунта"))
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                    case .first:
                        return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Хорошо")))
                    case .second:
                        return Alert(title: Text("Эл.почта изменена!"), message: Text("Вы успешно изменили свою электронную почту."), dismissButton: .default(Text("Выйти")) {
                            //self.session.signOut()
                        }
                    )
                }
            }
        }
    }
}

struct ChangePassword: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var textError: String = ""

    @EnvironmentObject var session: SessionStore
    
    private func reauthenticateUser() {
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
        NavigationView {
            VStack(alignment: .center) {
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: $password)
                        if password.isEmpty {
                        
                        }
                        if 0 < password.count && password.count < 8 {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        if 8 <= password.count{
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
            .navigationBarTitle(Text("Удаление аккаунта"))
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                    case .first:
                        return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Хорошо")))
                    case .second:
                        return Alert(title: Text("Аккаунт удален!"), message: Text("Мне очень жаль, что вы решили удалить аккаунт в моем приложение, надеюсь вы скоро вернетесь:)"), dismissButton: .default(Text("Выйти")) {
                            //self.session.signOut()
                        }
                    )
                }
            }
        }
    }
}

enum ActiveAlert {
    case first, second
}

struct Credential_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUser()
    }
}
