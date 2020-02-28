//
//  PrivacySplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 04.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct PrivacySplashScreen: View {
    
    @Binding var dismissSheet: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                TitlePrivacyView()
                    .padding(.bottom)
                    .padding(.top, 50)
                    .accentColor(.defaultColorApp)
                PrivacyContainerView()
                    .padding(.bottom, 50)
                    .accentColor(.defaultColorApp)
            }
            Spacer()
            VStack {
                NavigationLink(destination: PermissionSplashScreen(dismissSheet: $dismissSheet)) {
                    Text("Продолжить")
                        .customButton()
                }
                Text("Продолжая вы соглашаетесь с этой")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://lisindmitriy.me/privacyaltgtu/")!)
                }) {
                    Text("Политикой конфиденциальности.")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.defaultColorApp)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct PrivacyContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Синхронизация", subTitle: "Все ваши данные легко синхронизируются с любыми вашими устройствоми, которые также используют это приложение.", imageName: "arrow.2.circlepath")
            InformationDetailView(title: "Шифрование", subTitle: "Все личные данные профиля и переписок надежно шифруются сквозным шифрованием, ключ к этим данным есть только у вас.", imageName: "lock.shield")
            InformationDetailView(title: "Новости", subTitle: "Узнавайте все новости из мира и жизни университета.", imageName: "doc.richtext")
        }.padding(.horizontal)
    }
}

struct TitlePrivacyView: View {
    var body: some View {
        VStack {
            Image(systemName: "lock.icloud.fill")
                .resizable()
                .frame(width: 100, height: 70)
                .foregroundColor(.accentColor)
            Text("Ваши данные и")
                .customTitleText()
            Text("конфиденциальность")
                .customTitleText()
        }
    }
}
