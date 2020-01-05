//
//  LoginScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import AuthenticationServices

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    
    @EnvironmentObject var session: SessionStore

    func signUp() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        session.signUp(email: email, password: password) { (result, error) in
            if error != nil {
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
                    "notifyAlertProfile": false,
                    "dateBirthDay": NSDate(),
                    "adminSetting": false,
                    "notifyMinute": 10,
                    "pinCodeAccess": "",
                    "boolCodeAccess": false,
                    "biometricAccess": false,
                    "urlImageProfile": "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
                ]) {
                    err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        self.session.sendEmailVerification()
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
                    }.modifier(InputModifier())
                Text("Требуется минимум 8 символов.")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
                .padding(.horizontal)
                .padding(.bottom, 8)
            CustomButton(label: loading == true ? "Загрузка" : "Зарегистрироваться", action: signUp, loading: loading)
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
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil)
        .navigationBarTitle("Регистрация")
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Некорректные данные!"), message: Text("Возможно, что эта почта уже использовалась для регистрации или пароль слишком короткий!"), dismissButton: .default(Text("Хорошо")))
        }
    }
}


struct ResetPassword: View {
    
    @State private var email: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false
    @State private var choiceAlert: Int = 1

    @EnvironmentObject var session: SessionStore
    
    func sendPasswordReset() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        session.sendPasswordReset(email: email) { (error) in
            if error != nil {
                self.loading = false
                self.email = ""
                self.choiceAlert = 1
                self.showAlert = true
                print("Ошибка, пользователя не существует!")
            } else {
                self.email = ""
                self.choiceAlert = 2
                self.showAlert = true
                print("Письмо отправлено!")
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            CustomInput(text: $email, name: "Эл.почта")
                .padding([.top, .horizontal])
                .keyboardType(.emailAddress)
            CustomButton(label: loading == true ? "Загрузка" : "Восстановить аккаунт", action: sendPasswordReset, loading: loading)
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
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil)
        .navigationBarTitle("Восстановление")
        .alert(isPresented: $showAlert) {
            Alert(title: Text(choiceAlert == 1 ? "Ошибка!" : "Проверьте почту!"), message: Text(choiceAlert == 1 ? "Пользователь с этой почтой не зарегистрирован в приложении!" : "Проверьте вашу почту и перейдите по ссылке в письме!"), dismissButton: .default(Text("Хорошо")))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct EmailLoginScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loading: Bool = false
    @State private var showAlert: Bool = false

    @EnvironmentObject var session: SessionStore
    
    func signIn() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        loading = true
        session.signIn(email: email, password: password) { (result, error) in
            if error != nil {
                self.loading = false
                self.showAlert = true
                self.email = ""
                self.password = ""
            } else {
        
            }
        }
    }

    var body: some View {
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
                NavigationLink(destination: ResetPassword()) {
                    Text("Забыли пароль?")
                        .font(.footnote)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
            CustomButton(label: loading == true ? "Загрузка" : "Войти", action: signIn, loading: loading)
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
            VStack {
                Divider()
                    .padding(.bottom)
                HStack(alignment: .center) {
                    Text("У вас еще нет аккаунта?")
                        .font(.footnote)
                        .foregroundColor(.gray)
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
                Alert(title: Text("Неправильный логин или пароль!"), message: Text("Проверьте правильность введенных данных учетной записи!"), dismissButton: .default(Text("Хорошо")))
        }
    }
}

struct AuthenticationScreen: View {
    
    @State private var showSpashScreen: Bool = false

    @EnvironmentObject var session: SessionStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func funcSplashScreen() {
        let defaults = UserDefaults.standard
            if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
                print("НЕ первый запуск")
                self.showSpashScreen = false
            }else{
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                print("Первый запуск")
                self.showSpashScreen = true
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                VStack {
                    Image("altgtu")
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text("Личный кабинет")
                        .font(.system(size: 32, weight: .black))
                        .multilineTextAlignment(.center)
                    Text("АлтГТУ")
                        .font(.system(size: 32, weight: .black))
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    Text("Самый простой способ узнать расписание и")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal)
                    Text("быть в курсе всех событий.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding([.horizontal, .bottom])
                }.padding(.top, 30)
                Spacer()
                VStack {
                    if self.colorScheme == .light {
                        SignInWithAppleBlack()
                            .frame(height: 55)
                            .cornerRadius(8)
                            .padding()
                            .onTapGesture(perform: self.session.startSignInWithAppleFlow)
                    } else {
                        SignInWithAppleWhite()
                            .frame(height: 55)
                            .cornerRadius(8)
                            .padding()
                            .onTapGesture(perform: self.session.startSignInWithAppleFlow)
                    }
                    Text("-или-")
                        .foregroundColor(.gray)
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
            .sheet(isPresented: self.$showSpashScreen) {
                    SplashScreen()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.defaultColorApp)
        .onAppear(perform: funcSplashScreen)
    }
}

final class SignInWithAppleWhite: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .default, style: .white)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    
    }
}

final class SignInWithAppleBlack: UIViewRepresentable {
        
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .default, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    
    }
}

struct Authenticate_Previews : PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
            .environmentObject(SessionStore())
    }
}
