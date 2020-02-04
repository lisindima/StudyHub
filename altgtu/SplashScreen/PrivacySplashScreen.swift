//
//  PrivacySplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 04.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct PrivacySplashScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showPolicyView: Bool = false
    @Binding var dismissSheet: Bool
    
    func showPolicy() {
        showPolicyView = true
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            TitlePrivacyView()
                .padding(.bottom)
            PrivacyContainerView()
            Spacer(minLength: 30)
            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.dismissSheet = false
            }) {
                Text("Продолжить")
                    .customButton()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            Text("Продолжая вы соглашаетесь с этой")
                .font(.footnote)
                .foregroundColor(.secondary)
            Button(action: showPolicy) {
                Text("Политикой конфиденциальности.")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.defaultColorApp)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $showPolicyView) {
            Privacy()
        }
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
            Text("Ваши данные и")
                .customTitleText()
            Text("конфиденциальность")
                .customTitleText()
        }
    }
}
