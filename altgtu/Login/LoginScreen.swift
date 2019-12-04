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
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
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
                    "urlImageProfile": "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
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
        LoadingView(isShowing: .constant(loading)) {
            VStack {
                CustomInput(text: self.$lastname, name: "Фамилия")
                    .padding([.top, .horizontal])
                CustomInput(text: self.$firstname, name: "Имя")
                    .padding([.top, .horizontal])
                CustomInput(text: self.$email, name: "Эл.почта")
                    .padding()
                    .keyboardType(.emailAddress)
                VStack(alignment: .trailing) {
                    HStack {
                        SecureField("Пароль", text: self.$password)
                            if self.password.isEmpty {
                    
                            }
                            if 0 < self.password.count && self.password.count < 8 {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                            if 8 <= self.password.count{
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
                    action: self.signUp
                )
                    .disabled(self.loading)
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
            .alert(isPresented: self.$showAlert){
                Alert(title: Text("Некорректные данные!"), message: Text("Возможно, что эта почта уже использовалась для регистрации или пароль слишком короткий!"), dismissButton: .default(Text("Хорошо")))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}


struct ResetPassword: View {
    
@State private var email: String = ""
@State private var loading = false
@State private var error = false
@State private var showAlert = false

@EnvironmentObject var session: SessionStore
    
    func sendPasswordReset () {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
        LoadingView(isShowing: .constant(loading)) {
            Group {
                VStack {
                    CustomInput(text: self.$email, name: "Эл.почта")
                        .padding([.top, .horizontal])
                        .keyboardType(.emailAddress)
                    VStack(alignment: .trailing) {
                        HStack {
                            SecureField("Пароль", text: self.$password)
                            if self.password.isEmpty {
                    
                            }
                            if 0 < self.password.count && self.password.count < 8 {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                            if 8 <= self.password.count{
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
                        action: self.signIn
                    )
                        .disabled(self.loading)
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
                    .alert(isPresented: self.$showAlert) {
                        Alert(title: Text("Неправильный логин или пароль!"), message: Text("Проверьте правильность введенных данных учетной записи!"), dismissButton: .default(Text("Хорошо")))
                }
            }
        }
    }
}

struct AuthenticationScreen : View {
    
@State private var email: String = ""
@State private var password: String = ""
@State private var loading = false
@State private var error = false
@State private var showAlert = false
@State private var showSpashScreen = false

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
        Group {
            NavigationView {
                VStack {
                    Spacer()
                    VStack {
                        Image("altgtu")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Text("Личный кабинет")
                            .fontWeight(.black)
                            .font(.system(size: 36))
                            .multilineTextAlignment(.center)
                        Text("АлтГТУ")
                            .fontWeight(.black)
                            .font(.system(size: 36))
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
                        Text("Войти с помощью эл.почты").font(.headline)
                            .foregroundColor(self.colorScheme == .light ? .black : .white)
                            .padding()
                        }
                    }.padding(.bottom, 40)
                }
                .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                .edgesIgnoringSafeArea(.top)
                .sheet(isPresented: self.$showSpashScreen) {
                    SplashScreen()
                }
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("Неправильный логин или пароль!"), message: Text("Проверьте правильность введенных данных учетной записи!"), dismissButton: .default(Text("Хорошо")))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }.onAppear(perform: funcSplashScreen)
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                VStack {
                    LottieView(filename: "27-loading")
                }
                .frame(width: 200,
                       height: 200)
                .background(Color(#colorLiteral(red: 0.213772162, green: 0.2300552888, blue: 0.2528391964, alpha: 0.7704390405)))
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
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
