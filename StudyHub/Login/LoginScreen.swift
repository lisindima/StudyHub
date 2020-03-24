//
//  LoginScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase

// MARK: - Регистрация

struct SignUpView: View {
    
    @EnvironmentObject var sessionStore: SessionStore

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var textError: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false

    private func signUp() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        sessionStore.signUp(email: email, password: password) { result, error in
            if error != nil {
                self.textError = (error?.localizedDescription)!
                self.loading = false
                self.showAlert = true
                self.email = ""
                self.password = ""
                self.firstname = ""
                self.lastname = ""
            } else {
                let currentUser = Auth.auth().currentUser!
                let db = Firestore.firestore()
                db.collection("profile").document(currentUser.uid).setData([
                    "firstname": self.firstname,
                    "lastname": self.lastname,
                    "email": self.email,
                    "rValue": 88.0,
                    "gValue": 86.0,
                    "bValue": 214.0,
                    "darkThemeOverride": false,
                    "dateBirthDay": Timestamp(),
                    "adminSetting": false,
                    "notifyMinute": 10,
                    "pinCodeAccess": "",
                    "boolCodeAccess": false,
                    "biometricAccess": false,
                    "choiseTypeBackroundProfile": false,
                    "setImageForBackroundProfile": "",
                    "choiseFaculty": 1,
                    "choiseGroup": 1,
                    "urlImageProfile": "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
                ]) {
                    err in
                    if let err = err {
                        self.textError = err.localizedDescription
                        print("Error writing document: \(err)")
                    } else {
                        self.sessionStore.sendEmailVerification()
                        print("Document successfully written!")
                    }
                }
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CustomInput(text: $lastname, name: "Фамилия")
                .padding([.top, .horizontal])
            CustomInput(text: $firstname, name: "Имя")
                .padding([.top, .horizontal])
            CustomInput(text: $email, name: "Эл.почта")
                .padding()
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            VStack(alignment: .trailing) {
                HStack {
                    SecureField("Пароль", text: $password)
                        .textContentType(.newPassword)
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
                }.modifier(InputModifier())
                Text("Требуется минимум 8 символов.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            CustomButton(label: loading ? "Загрузка" : "Зарегистрироваться", action: signUp, loading: loading, colorButton: Color.defaultColorApp)
                .disabled(loading)
                .padding()
            Divider()
            Text("Учетная запись позволит вам сохранять и получать доступ к информации на разных устройствах. Вы можете удалить свою учетную запись в любое время.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
            Spacer()
        }
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil)
        .navigationBarTitle("Регистрация")
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Закрыть")))
        }
    }
}

// MARK: - Восстановление пароля

struct ResetPassword: View {

    @EnvironmentObject var sessionStore: SessionStore
    
    @State private var email: String = ""
    @State private var textError: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .first

    private func sendPasswordReset() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        sessionStore.sendPasswordReset(email: email) { (error) in
            if error != nil {
                self.textError = (error?.localizedDescription)!
                self.loading = false
                self.email = ""
                self.activeAlert = .first
                self.showAlert = true
                print("Ошибка, пользователь не существует!")
            } else {
                self.loading = false
                self.email = ""
                self.activeAlert = .second
                self.showAlert = true
                print("Письмо отправлено!")
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CustomInput(text: $email, name: "Эл.почта")
                .padding([.top, .horizontal])
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            CustomButton(label: loading ? "Загрузка" : "Восстановить аккаунт", action: sendPasswordReset, loading: loading, colorButton: Color.defaultColorApp)
                .disabled(loading)
                .padding()
            Divider()
            Text("После нажатия на кнопку зайдите на почту и следуйте инструкции по восстановлению доступа к аккаунту.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
            Spacer()
        }
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil)
        .navigationBarTitle("Восстановление")
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .first:
                return Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Закрыть")))
            case .second:
                return Alert(title: Text("Проверьте почту!"), message: Text("Проверьте вашу почту и перейдите по ссылке в письме!"), dismissButton: .default(Text("Закрыть")))
            }
        }
    }
}

// MARK: - Вход с помощью почты и пароля

struct EmailLoginScreen: View {
    
    @EnvironmentObject var sessionStore: SessionStore

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var textError: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false

    private func signIn() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        sessionStore.signIn(email: email, password: password) { (result, error) in
            if error != nil {
                self.textError = (error?.localizedDescription)!
                self.loading = false
                self.showAlert = true
                self.email = ""
                self.password = ""
            }
        }
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
                NavigationLink(destination: ResetPassword()) {
                    Text("Забыли пароль?")
                        .font(.footnote)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
            CustomButton(label: loading ? "Загрузка" : "Войти", action: signIn, loading: loading, colorButton: Color.defaultColorApp)
                .disabled(loading)
                .padding()
            Divider()
            Text("После нажатия на кнопку зайдите на почту и следуйте инструкции по восстановлению доступа к аккаунту.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding()
            Spacer()
            VStack {
                Divider()
                    .padding(.bottom)
                HStack(alignment: .center) {
                    Text("У вас еще нет аккаунта?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    NavigationLink(destination: SignUpView()) {
                        Text("Регистрация")
                            .font(.footnote)
                    }
                }
                .padding(.top, 5)
                .padding(.bottom)
            }.padding(.bottom)
        }
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil)
        .navigationBarTitle("Вход")
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Ошибка!"), message: Text("\(textError)"), dismissButton: .default(Text("Закрыть")))
        }
    }
}

// MARK: - Вход с помощью Apple

struct AuthenticationScreen: View {

    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                VStack {
                    Image("defaultlogo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text("StudyHub")
                        .font(.system(size: 32, weight: .black))
                        .padding(.bottom, 10)
                    Text("Самый простой способ узнать расписание и")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal)
                    Text("быть в курсе всех событий.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding([.horizontal, .bottom])
                }.padding(.top, 30)
                Spacer()
                VStack {
                    SignInWithAppleButton()
                        .frame(height: 55)
                        .cornerRadius(8)
                        .padding()
                        .onTapGesture(perform: self.sessionStore.startSignInWithAppleFlow)
                    Text("-или-")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    NavigationLink(destination: EmailLoginScreen()) {
                        Text("Войти с помощью эл.почты")
                            .font(.headline)
                            .foregroundColor(self.colorScheme == .light ? .black : .white)
                            .padding()
                    }
                }.padding(.bottom, 40)
            }
            .frame(minWidth: nil, idealWidth: 400, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil)
            .edgesIgnoringSafeArea(.top)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.defaultColorApp)
    }
}
