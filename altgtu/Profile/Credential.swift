//
//  Credential.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 06.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

struct CredentialDeleteUser: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var choiceAlert: Int = 1

    @EnvironmentObject var session: SessionStore
    
    private func reauthenticateUser() {
        let credentialEmail = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credentialEmail, completion: { (authResult, error) in
            if error != nil {
                print((error?.localizedDescription)!)
            } else {
                print("User re-authenticated.")
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
                Alert(title: Text(choiceAlert == 1 ? "Ошибка!" : "Проверьте почту!"), message: Text(choiceAlert == 1 ? "Пользователь с этой почтой не зарегистрирован в приложении!" : "Проверьте вашу почту и перейдите по ссылке в письме!"), dismissButton: .default(Text("Хорошо")))
            }
        }
    }
}

struct Credential_Previews: PreviewProvider {
    static var previews: some View {
        CredentialDeleteUser()
    }
}
