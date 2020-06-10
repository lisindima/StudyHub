//
//  SubscriptionSplashScreen.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 16.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct SubscriptionSplashScreen: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject private var purchasesStore: PurchasesStore = PurchasesStore.shared
    
    var body: some View {
        VStack {
            ScrollView {
                SubscriptionTitleView()
                    .padding(.bottom)
                    .padding(.top, 50)
                    .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                SubscriptionContainerView()
                    .padding(.bottom, 50)
                    .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
            }
            Spacer()
            if !purchasesStore.purchasesInfo!.activeSubscriptions.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        .frame(maxWidth: .infinity, maxHeight: 72)
                    Text("Подписка оформлена!")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                }
                .padding(.top, 8)
                .padding(.horizontal)
            } else {
                HStack {
                    Button(action: {
                        self.purchasesStore.buySubscription(package: self.purchasesStore.offering!.monthly!)
                        self.purchasesStore.loadingMonthlyButton = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                .opacity(0.2)
                                .frame(maxWidth: .infinity, maxHeight: 72)
                            if purchasesStore.loadingMonthlyButton {
                                ActivityIndicator(styleSpinner: .medium)
                            } else {
                                VStack {
                                    Text("Ежемесячно")
                                        .fontWeight(.bold)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(purchasesStore.monthlyPrice)
                                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                }
                            }
                        }
                    }
                    .disabled(self.purchasesStore.loadingAnnualButton)
                    .padding(.trailing, 4)
                    Button(action: {
                        self.purchasesStore.buySubscription(package: self.purchasesStore.offering!.annual!)
                        self.purchasesStore.loadingAnnualButton = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                .frame(maxWidth: .infinity, maxHeight: 72)
                            if purchasesStore.loadingAnnualButton {
                                ActivityIndicator(styleSpinner: .medium)
                            } else {
                                VStack {
                                    Text("Ежегодно")
                                        .fontWeight(.bold)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(purchasesStore.annualPrice)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .disabled(self.purchasesStore.loadingMonthlyButton)
                    .padding(.leading, 4)
                }
                .padding(.top, 8)
                .padding(.horizontal)
            }
            HStack {
                Button(action: purchasesStore.restoreSubscription) {
                    Text("Восстановить платеж")
                        .font(.footnote)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                }
                Text("|")
                    .font(.footnote)
                    .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://studyhub.lisindmitriy.me/privacypolicy/")!)
                }) {
                    Text("Политика")
                        .font(.footnote)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                }
                Text("|")
                    .font(.footnote)
                    .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://studyhub.lisindmitriy.me/privacypolicy/")!)
                }) {
                    Text("Правила")
                        .font(.footnote)
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                }
            }.padding(.vertical)
        }.onAppear(perform: purchasesStore.fetchProduct)
    }
}

struct SubscriptionTitleView: View {
    var body: some View {
        VStack {
            Image(systemName: "plus.app.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentColor)
            HStack {
                Text("StudyHub")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Text("Plus")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
            }
            Text("После приобретения подписки вы получите больше функций для еще лучшего опыта использования приложения.")
                .font(.system(size: 14))
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
            InformationDetailView(title: "Удаление рекламы", subTitle: "Полное удаление рекламы из приложения.", imageName: "tag")
            InformationDetailView(title: "Поддержка", subTitle: "Оформляя подписку вы поддерживаете разработчика и позволяете развиваться приложению.", imageName: "heart")
        }.padding(.horizontal)
    }
}

struct InformationDetailView: View {
    
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .frame(width: 30)
                .foregroundColor(.accentColor)
                .padding()
                .accessibility(hidden: true)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
