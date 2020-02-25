//
//  InfoApp.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 15.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct InfoApp: View {
    
    @ObservedObject var iconStore: IconStore = IconStore.shared
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    var buildVersion: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(iconStore.nameIcon == .primary ? "infoApp" : "altIconApp")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(30)
                .shadow(radius: 10)
            Text("Личный кабинет")
                .fontWeight(.black)
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
            Text("АлтГТУ")
                .fontWeight(.black)
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
            HStack {
                Text("Версия \(appVersion)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Сборка \(buildVersion)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }.padding(.bottom)
            VStack(alignment: .leading) {
                Text("Разработка и дизайн:").bold().font(.caption) + Text(" Дмитрий Лисин").font(.caption)
                Text("Иконка приложения:").bold().font(.caption) + Text(" Дмитрий Лисин").font(.caption)
            }
            .padding(.horizontal)
            .padding(.bottom)
            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://github.com/lisindima")!)
                }, label: {
                    Image("github")
                        .resizable()
                        .frame(width: 25, height: 25)
                }).padding(.horizontal, 8)
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://twitter.com/lisindima")!)
                }, label: {
                    Image("twitter")
                        .resizable()
                        .frame(width: 25, height: 25)
                }).padding(.horizontal, 8)
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://vk.com/lisindima")!)
                }, label: {
                    Image("vk")
                        .resizable()
                        .frame(width: 25, height: 25)
                }).padding(.horizontal, 8)
            }
            Spacer()
            VStack(alignment: .leading) {
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://money.yandex.ru/to/410017490181618")!)
                }, label: {
                    HStack {
                        Image(systemName: "creditcard")
                            .frame(width: 24)
                        Text("Поддержать разработчика")
                    }
                })
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://testflight.apple.com/join/xE99ppRh")!)
                }, label: {
                    HStack {
                        Image(systemName: "ant")
                            .frame(width: 24)
                        Text("Принять участие в бета-тестирование")
                    }
                })
            }
            .padding(.bottom)
            .onAppear(perform: iconStore.getNameIcon)
            .navigationBarTitle(Text("О приложении"), displayMode: .inline)
        }
    }
}

struct InfoApp_Previews: PreviewProvider {
    static var previews: some View {
        InfoApp()
    }
}
