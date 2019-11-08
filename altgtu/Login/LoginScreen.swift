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
                    }
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
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
        .navigationBarTitle("Регистрация")
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
            CustomInput(text: $email, name: "Эл.почта")
                .padding([.top, .horizontal])
                .keyboardType(.emailAddress)
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
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
        .navigationBarTitle("Восстановление")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Проверьте почту!"), message: Text("Проверьте вашу почту и перейдите по ссылке в письме!"), dismissButton: .default(Text("Хорошо")))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct EmailLoginScreen: View {
    
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

    var body : some View {
        VStack {
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
                    Text("Забыли пароль?").font(.footnote)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
            CustomButton(
                label: "Войти",
                action: signIn
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
                }.padding(.bottom)
            }
            .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            .navigationBarTitle("Вход")
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Неправильный логин или пароль!"), message: Text("Проверьте правильность введенных данных учетной записи!"), dismissButton: .default(Text("Хорошо")))
        }
    }
}

struct AuthenticationScreen : View {
    
@State private var email: String = ""
@State private var password: String = ""
@State private var loading = false
@State private var error = false
@State private var showAlert = false

@EnvironmentObject var session: SessionStore
@Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    Image("altgtu")
                        .resizable()
                        .frame(width: 135, height: 135)
                    Text("Личный кабинет АлтГТУ")
                        .font(.title)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    Text("Самый простой способ узнать расписание и быть в курсе всех событий.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding([.horizontal, .bottom])
                }.padding(.top, 30)
                Spacer()
                VStack {
                    SignInWithApple()
                        .frame(height: 55)
                        .cornerRadius(8)
                        .padding()
                        .onTapGesture(perform: showAppleLogin)
                    Text("-или-")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    NavigationLink(destination: EmailLoginScreen()) {
                    Text("Войти с помощью эл.почты").font(.headline)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .padding()
                    }
                }.padding(.bottom, 40)
            }
            .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            .edgesIgnoringSafeArea(.top)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Неправильный логин или пароль!"), message: Text("Проверьте правильность введенных данных учетной записи!"), dismissButton: .default(Text("Хорошо")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

final class SignInWithApple: UIViewRepresentable {
    
@Environment(\.colorScheme) var colorScheme: ColorScheme
    
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    return ASAuthorizationAppleIDButton(type: .default, style: colorScheme == .light ? .black : .white)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

private func showAppleLogin() {
  // 1
  let request = ASAuthorizationAppleIDProvider().createRequest()

  // 2
  request.requestedScopes = [.fullName, .email]

  // 3
  let controller = ASAuthorizationController(authorizationRequests: [request])
}

struct Authenticate_Previews : PreviewProvider {
    static var previews: some View {
        AuthenticationScreen()
            .environmentObject(SessionStore())
    }
}
