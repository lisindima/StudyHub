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
                }
            }
        }
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
        .navigationTitle("Настройки аккаунта")
    }
}

struct SetAuth_Previews: PreviewProvider {
    static var previews: some View {
        SettingAccount()
    }
}
