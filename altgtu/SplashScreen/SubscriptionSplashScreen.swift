//
//  SubscriptionSplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 16.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct SubscriptionSplashScreen: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var purchasesStore: PurchasesStore = PurchasesStore.shared
    
    @State private var loadingMonthlySubscription: Bool = false
    @State private var loadingAnnualSubscription: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                TitleSubscriptionView()
                    .padding(.bottom)
                    .padding(.top, 50)
                    .accentColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                SubscriptionContainerView()
                    .padding(.bottom, 50)
                    .accentColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
            }
            Spacer()
            HStack {
                Button(action: {
                    self.purchasesStore.buySubscription(package: (self.purchasesStore.offering?.monthly)!)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 0.2))
                            .frame(maxWidth: .infinity, maxHeight: 72)
                        if loadingMonthlySubscription {
                            ActivityIndicator(styleSpinner: .medium)
                        } else {
                            VStack {
                                Text("Ежемесячно")
                                    .bold()
                                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                                Text(purchasesStore.monthlyPrice)
                                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            }
                        }
                    }
                }.padding(.trailing, 4)
                Button(action: {
                    self.purchasesStore.buySubscription(package: (self.purchasesStore.offering?.annual)!)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            .frame(maxWidth: .infinity, maxHeight: 72)
                        if loadingAnnualSubscription {
                            ActivityIndicator(styleSpinner: .medium)
                        } else {
                            VStack {
                                Text("Ежегодно")
                                    .bold()
                                    .foregroundColor(.white)
                                Text(purchasesStore.annualPrice)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }.padding(.leading, 4)
            }
            .padding(.top, 8)
            .padding(.horizontal)
            HStack {
                Button(action: purchasesStore.restoreSubscription) {
                    Text("Восстановить платеж")
                        .font(.footnote)
                        .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                }
                Text("|")
                    .font(.footnote)
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://lisindmitriy.me/privacyaltgtu/")!)
                }) {
                    Text("Политика")
                        .font(.footnote)
                        .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                }
                Text("|")
                    .font(.footnote)
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://lisindmitriy.me/privacyaltgtu/")!)
                }) {
                    Text("Правила")
                        .font(.footnote)
                        .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                }
            }.padding(.vertical)
        }
        .onAppear(perform: purchasesStore.fetchProduct)
    }
}

struct TitleSubscriptionView: View {
    var body: some View {
        VStack {
            Image(systemName: "plus.app.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentColor)
            Text("Оформление")
                .customTitleText()
            Text("подписки")
                .customTitleText()
            Text("После приобретения подписки вы получите больше функций для еще лучшего опыта использования приложения.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.top)
                .padding(.horizontal)
        }
    }
}

struct SubscriptionContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Изменение иконки", subTitle: "Измените стандартную иконку приложения на любую другую, которая придется по вкусу!", imageName: "app")
            InformationDetailView(title: "Изменение цвета акцентов", subTitle: "Вы сможете менять цвет акцентов в приложении, на абсолютно любой!", imageName: "paintbrush")
            InformationDetailView(title: "Тёмная тема", subTitle: "Темная тема теперь всегда! Конечно, если вы этого захотите)", imageName: "moon")
            InformationDetailView(title: "Изменение обложки профиля", subTitle: "Для тех кто хочет выделиться! Установите вместо обычной цветной обложки, фотографию из Unsplash!", imageName: "rectangle")
            InformationDetailView(title: "Удаление рекламы", subTitle: "Полное удаление рекламы из приложения.", imageName: "tag")
            InformationDetailView(title: "Поддержка", subTitle: "Оформляя подписку вы поддерживаете разработчика и позволяете развиваться приложению.", imageName: "heart")
        }.padding(.horizontal)
    }
}

struct SubscriptionSplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionSplashScreen()
    }
}
