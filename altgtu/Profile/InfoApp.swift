//
//  InfoApp.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 15.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct InfoApp: View {
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    var buildVersion: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("infoApp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(30)
                .shadow(radius: 10)

            Text("Личный кабинет АлтГТУ")
                .font(.title)
            HStack(spacing: 5) {
                Text("Версия \(appVersion)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Сборка \(buildVersion)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.padding(.bottom)
            VStack(alignment: .leading) {
                Text("Разработка и дизайн:").bold().font(.caption) + Text(" Дмитрий Лисин").font(.caption)
                Text("Иконка приложения:").bold().font(.caption) + Text(" А хрен его знает...").font(.caption)
            }
            .padding(.horizontal)
                Spacer()
            VStack(alignment: .leading) {
                NavigationLink(
                    destination: Payment(),
                    label: {
                        HStack {
                            Image(systemName: "creditcard")
                            Text("Скинуть разработчику на кофе :)")
                        }
                })
                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "mailto:lisindima1996@gmail.com")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Есть отзыв? Отправьте его по почте")
                        }
                })
                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "https://testflight.apple.com/join/xE99ppRh")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "ant")
                            Text("Принять участие в бета-тестирование")
                        }
                })
            }.padding(.bottom)
            .navigationBarTitle(Text("О приложении"), displayMode: .inline)
        }
    }
}

struct InfoApp_Previews: PreviewProvider {
    static var previews: some View {
        InfoApp()
    }
}
