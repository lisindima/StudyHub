//
//  LoginScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import KeyboardObserving

struct SignUpView : View {
    
@State private var email: String = ""
@State private var password: String = ""
@State private var firstname: String = ""
@State private var lastname: String = ""
@State private var loading = false
@State private var error = false
@State private var showAlert = false
    
@EnvironmentObject var session: SessionStore

func signUp () {
    loading = true
    error = false
    session.signUp(email: email, password: password) { (result, error) in
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
            db.collection("profile").document(currentUser.uid)
                .setData([
                    "firstname": self.firstname,
                    "lastname": self.lastname,
                    "email": self.email,
                    "NotifyAlertProfile": false,
                    "DateBirthDay": NSDate(),
                    "adminSetting": false,
                    "NotifyMinute": 10,
                    "urlImageProfile": "https://icon-library.net/images/no-image-icon/no-image-icon-13.jpg"
                        ])
        {
            err in
            if let err = err {
                print("Error writing document: \(err)")
            }
                else
            {
                print("Document successfully written!")
            }
        }
                self.loading = false
            if error != nil
            {
                self.showAlert.toggle()
                self.error = true
            }
                else
            {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body : some View {

        VStack {
            Text("Создание аккаунта")
                .font(.title)
                .padding(.horizontal)
            
            CustomInput(text: $lastname, name: "Фамилия")
                .padding([.top, .horizontal])
            CustomInput(text: $firstname, name: "Имя")
                .padding([.top, .horizontal])
            CustomInput(text: $email, name: "Эл.почта")
                .padding()
            
            VStack(alignment: .trailing) {
                SecureField("Пароль", text: $password)
                    .modifier(InputModifier())
                Text("Требуется минимум 8 символов.")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
                .padding(.horizontal)
                .padding(.bottom, 8)
            CustomButton(
                label: "Зарегистрироваться",
                action: signUp
            )
                .disabled(loading)
                .padding()
            Divider()
            Text("Учетная запись позволит вам сохранять и получать доступ к информации на разных устройствах. Вы можете удалить свою учетную запись в любое время.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
            Spacer()
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Некорректные данные!"), message: Text("Возможно, что эта почта уже использовалась для регистрации или пароль слишком короткий!"), dismissButton: .default(Text("Хорошо")))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct ResetPassword: View {
    
@State private var email: String = ""
@State private var loading = false
@State private var error = false
@State private var showAlert = false

@EnvironmentObject var session: SessionStore
    
    func sendPasswordReset () {
        loading = true
        error = true
        showAlert = true
        session.sendPasswordReset(email: email) { (result, error) in
            self.loading = false
            if error != nil {
            }
                else
            {
                self.email = ""
            }
        }
    }

    var body : some View {
        VStack {
            Text("Восстановление аккаунта")
                .font(.title)
                .padding(.horizontal)
                
                CustomInput(text: $email, name: "Эл.почта")
                    .padding([.top, .horizontal])
                CustomButton(
                    label: "Восстановить аккаунт",
                    action: sendPasswordReset
                )
                    .disabled(loading)
                    .padding()
                Divider()
                Text("После нажатия на кнопку зайдите на почту и следуйте инструкции по восстановлению доступа к аккаунту.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding()
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Проверьте почту!"), message: Text("Проверьте вашу почту и перейдите по ссылке в письме!"), dismissButton: .default(Text("Хорошо")))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AuthenticationScreen : View {
    
@State private var email: String = ""
@State private var password: String = ""
@State private var loading = false
@State private var error = false
@State private var showAlert = false

@EnvironmentObject var session: SessionStore
    
    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.showAlert.toggle()
                self.error = true
            }
                else
            {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    Image("altgtu")
                        .resizable()
                        .frame(width: 135, height: 135)
                    Text("Личный кабинет АлтГТУ")
                        .font(.title)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    Text("Самый простой способ узнать расписание и быть в курсе всех событий.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding([.horizontal, .bottom])
                        
                Group {
                    Divider()
                        .padding(.top, 40)
                    CustomInput(text: $email, name: "Эл.почта")
                        .padding()
                        .keyboardType(.emailAddress)
                    VStack(alignment: .trailing) {
                    SecureField("Пароль", text: $password)
                        .modifier(InputModifier())
                        .padding([.leading, .trailing])
                    NavigationLink(destination: ResetPassword()) {
                        Text("Забыли пароль?").font(.footnote)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        }
                    }
                    
                    CustomButton(
                        label: "Войти",
                        action: signIn,
                        loading: loading
                    )
                        .padding()
                }
                VStack {
                    Divider()
                    HStack(alignment: .center) {
                        Text("У вас еще нет аккаунта?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    NavigationLink(destination: SignUpView())
                    {
                    Text("Регистрация").font(.footnote)
                        }
                    }
                        .padding(.top,5)
                        .padding(.bottom)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Неправильный логин или пароль!"), message: Text("Проверьте правильность введенных данных учетной записи!"), dismissButton: .default(Text("Хорошо")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .keyboardObserving()
    }
}

struct Authenticate_Previews : PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
            .environmentObject(SessionStore())
    }
}
