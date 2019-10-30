//
//  LoginScreeWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 14.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LoginScreenWatch: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var signInSuccess: Bool
    
    var body: some View {
        ScrollView {
            Text("Личный кабинет АлтГТУ")
                .multilineTextAlignment(.center)
            TextField("Логин", text: $email)
            TextField("Пароль", text: $password)
            Button("Войти") {
                self.signInSuccess.toggle()
            }
            Text("Для регистрации воспользуйтесь приложением для iPhone")
                .font(.footnote)
        }
    }
}

struct Login: View {
    
    @State private var signInSuccess = false
    
    var body: some View {
        Group {
            if signInSuccess {
                LessonWatch(signInSuccess: $signInSuccess)
            } else {
                LoginScreenWatch(signInSuccess: $signInSuccess)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
