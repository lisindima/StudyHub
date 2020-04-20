//
//  SettingAccount.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct SettingAccount: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    
    @State private var showActionSheetImage: Bool = false
    @State private var isShowingModalViewImage: Bool = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    private let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
    
    var body: some View {
        Form {
            Section(header: Text("Личные данные").fontWeight(.bold), footer: Text("Здесь вы можете отредактировать ваши личные данные, их могут видеть другие пользователи.")) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                    TextField("Фамилия", text: $sessionStore.lastname)
                }
                HStack {
                    Image(systemName: "person.crop.circle")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                    TextField("Имя", text: $sessionStore.firstname)
                }
                DatePicker(selection: $sessionStore.dateBirthDay, displayedComponents: [.date], label: {
                    Image(systemName: "calendar")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                    Text("День рождения")
                })
                HStack {
                    Image(systemName: "photo")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                    Button("Изменить фотографию") {
                        self.showActionSheetImage = true
                    }
                    .foregroundColor(.primary)
                    .actionSheet(isPresented: $showActionSheetImage) {
                        ActionSheet(title: Text("Изменение фотографии"), message: Text("Скорость, с которой отобразиться новая фотография в профиле напрямую зависит от размера выбранной вами фотографии."), buttons: [
                            .default(Text("Сделать фотографию")) {
                                self.selectedSourceType = .camera
                                self.isShowingModalViewImage = true
                            }, .default(Text("Выбрать фотографию")) {
                                self.selectedSourceType = .photoLibrary
                                self.isShowingModalViewImage = true
                            }, .destructive(Text("Удалить фотографию")) {
                                self.sessionStore.urlImageProfile = self.deletedUrlImageProfile
                            }, .cancel()
                        ])
                    }
                    .sheet(isPresented: $isShowingModalViewImage) {
                        ImagePicker(selectedSourceType: self.$selectedSourceType)
                            .accentColor(Color.rgb(red: self.sessionStore.rValue, green: self.sessionStore.gValue, blue: self.sessionStore.bValue))
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
            Section(header: Text("Аккаунты для входа").fontWeight(.bold), footer: Text("Активируя эти аккаунты, вы сможете входить в ваш профиль используя любой из них.")) {
                NavigationLink(destination: Changelog()) {
                    HStack {
                        Text("")
                            .font(.title)
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Вход через Apple")
                        Spacer()
                        Text("Выкл")
                            .foregroundColor(.secondary)
                    }
                }
                NavigationLink(destination: Changelog()) {
                    HStack {
                        Image(systemName: "envelope")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Вход через почту и пароль")
                        Spacer()
                        Text("Вкл")
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section {
                if sessionStore.userTypeAuth == .email {
                    NavigationLink(destination: ChangeEmail()) {
                        Image(systemName: "envelope")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Изменить эл.почту")
                    }
                    NavigationLink(destination: ChangePassword()) {
                        Image(systemName: "lock")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Изменить пароль")
                    }
                }
            }
            Section {
                NavigationLink(destination: DeleteUser()) {
                    Image(systemName: "flame")
                        .frame(width: 24)
                        .foregroundColor(.red)
                    Text("Удалить аккаунт")
                        .foregroundColor(.red)
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Настройки аккаунта", displayMode: .inline)
    }
}

struct SetAuth_Previews: PreviewProvider {
    static var previews: some View {
        SettingAccount()
    }
}
