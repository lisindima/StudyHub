//
//  SettingAccount.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct SettingAccount: View {
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var pickerStore = PickerStore.shared

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
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                    TextField("Фамилия", text: $sessionStore.userData.lastname)
                }
                HStack {
                    Image(systemName: "person.crop.circle")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                    TextField("Имя", text: $sessionStore.userData.firstname)
                }
                DatePicker(selection: $sessionStore.userData.dateBirthDay, displayedComponents: [.date], label: {
                    Image(systemName: "calendar")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                    Text("День рождения")
                })
                HStack {
                    Image(systemName: "photo")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                    Button("Изменить фотографию") {
                        showActionSheetImage = true
                    }
                    .foregroundColor(.primary)
                    .actionSheet(isPresented: $showActionSheetImage) {
                        ActionSheet(title: Text("Изменение фотографии"), message: Text("Скорость, с которой отобразиться новая фотография в профиле напрямую зависит от размера выбранной вами фотографии."), buttons: [
                            .default(Text("Сделать фотографию")) {
                                selectedSourceType = .camera
                                isShowingModalViewImage = true
                            }, .default(Text("Выбрать фотографию")) {
                                selectedSourceType = .photoLibrary
                                isShowingModalViewImage = true
                            }, .destructive(Text("Удалить фотографию")) {
                                sessionStore.userData.urlImageProfile = deletedUrlImageProfile
                            }, .cancel(),
                        ])
                    }
                    .sheet(isPresented: $isShowingModalViewImage) {
                        ImagePicker(selectedSourceType: $selectedSourceType)
                            .environmentObject(sessionStore)
                            .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
            Section(header: Text("Факультет и группа").fontWeight(.bold), footer: Text("Укажите свой факультет и группу, эти параметры влияют на расписание занятий.")) {
                Picker(selection: $sessionStore.userData.choiseFaculty, label: HStack {
                    Image(systemName: "list.bullet.below.rectangle")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                    Text("Факультет")
                }) {
                    ForEach(0 ..< pickerStore.facultyModel.count, id: \.self) {
                        Text(pickerStore.facultyModel[$0].name)
                    }
                }.lineLimit(1)
                Picker(selection: $sessionStore.userData.choiseGroup, label: HStack {
                    Image(systemName: "list.bullet.below.rectangle")
                        .frame(width: 24)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                    Text("Группа")
                }) {
                    ForEach(0 ..< pickerStore.groupModel.count, id: \.self) {
                        Text(pickerStore.groupModel[$0].name)
                    }
                }.lineLimit(1)
            }
            Section(header: Text("Аккаунты для входа").fontWeight(.bold), footer: Text("Активируя эти аккаунты, вы сможете входить в ваш профиль используя любой из них.")) {
                NavigationLink(destination: Changelog()) {
                    HStack {
                        Image(systemName: "applelogo")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
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
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
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
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Изменить эл.почту")
                    }
                    NavigationLink(destination: ChangePassword()) {
                        Image(systemName: "lock")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
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
