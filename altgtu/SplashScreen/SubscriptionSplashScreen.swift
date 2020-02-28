//
//  SubscriptionSplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 16.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import SPAlert
import Purchases

struct SubscriptionSplashScreen: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var purchasesStore: PurchasesStore = PurchasesStore.shared
    
    @State private var offering: Purchases.Offering?
    @State private var offeringId: String?
    @State private var showAlertSubscription: Bool = false
    @State private var loadingMonthlySubscription: Bool = false
    @State private var loadingAnnualSubscription: Bool = false
    @State private var setAlertMessage: SetAlertMessage = .error
    
    enum SetAlertMessage {
        case error
        case restoreUnsuccessful
        case restoreSuccessful
    }
    
    func buyMonthSubscription() {
        loadingMonthlySubscription = true
        let packageMonth = offering?.monthly
        Purchases.shared.purchasePackage(packageMonth!) { (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements.active.first != nil {
                if let error = error {
                    if userCancelled == true {
                        self.loadingMonthlySubscription = false
                        print("Отменено пользователем!")
                    } else {
                        self.loadingMonthlySubscription = false
                        SPAlert.present(title: "Произошла ошибка!", message: "Произошла ошибка, повторите попытку через несколько минут.", preset: .error)
                        print(error.localizedDescription)
                    }
                } else {
                    Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                        if let error = error {
                            self.loadingMonthlySubscription = false
                            self.setAlertMessage = .error
                            self.showAlertSubscription = true
                            print(error.localizedDescription)
                        } else {
                            self.purchasesStore.purchasesInfo = purchaserInfo
                            self.loadingMonthlySubscription = false
                            self.purchasesStore.getSubscriptionsExpirationDate()
                            SPAlert.present(title: "Подписка оформлена!", message: "Вы успешно оформили подписку, вы очень помогаете развитию приложения!", preset: .heart)
                        }
                    }
                }
            }
        }
    }
    
    func buyAnnualSubscription() {
        loadingAnnualSubscription = true
        let packageMonth = offering?.annual
        Purchases.shared.purchasePackage(packageMonth!) { (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements.active.first != nil {
                if let error = error {
                    if userCancelled == true {
                        self.loadingAnnualSubscription = false
                        print("Отменено пользователем!")
                    } else {
                        self.loadingAnnualSubscription = false
                        SPAlert.present(title: "Произошла ошибка!", message: "Произошла ошибка, повторите попытку через несколько минут.", preset: .error)
                        print(error.localizedDescription)
                    }
                } else {
                    Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                        if let error = error {
                            self.loadingAnnualSubscription = false
                            self.setAlertMessage = .error
                            self.showAlertSubscription = true
                            print(error.localizedDescription)
                        } else {
                            self.purchasesStore.purchasesInfo = purchaserInfo
                            self.loadingAnnualSubscription = false
                            self.purchasesStore.getSubscriptionsExpirationDate()
                            SPAlert.present(title: "Подписка оформлена!", message: "Вы успешно оформили подписку, вы очень помогаете развитию приложения!", preset: .heart)
                        }
                    }
                }
            }
        }
    }
    
    func restoreSubscription() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let purchaserInfo = purchaserInfo {
                    if purchaserInfo.entitlements.active.isEmpty {
                        print("Restore Unsuccessful")
                        self.setAlertMessage = .restoreUnsuccessful
                        self.showAlertSubscription = true
                    } else {
                        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                            if let error = error {
                                self.setAlertMessage = .error
                                self.showAlertSubscription = true
                                print(error.localizedDescription)
                            } else {
                                self.purchasesStore.purchasesInfo = purchaserInfo
                                SPAlert.present(title: "Подписка восстановлена!", message: "Подписка была восстановлена, премиум функции активированы.", preset: .heart)
                                self.purchasesStore.getSubscriptionsExpirationDate()
                                print("Обновляем подписки!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchProduct() {
        Purchases.shared.offerings { (offerings, error) in
            if let offeringId = self.offeringId {
                self.offering = offerings?.offering(identifier: offeringId)
            } else {
                self.offering = offerings?.current
            }
        }
    }
    
    var titleAlert: Text {
        switch setAlertMessage {
        case .error:
            return Text("Ошибка!")
        case .restoreUnsuccessful:
            return Text("Подписка не найдена!")
        case .restoreSuccessful:
            return Text("Подписка восстановлена!")
        }
    }
    
    var messageAlert: Text {
        switch setAlertMessage {
        case .error:
            return Text("Произошла ошибка, повторите попытку через несколько минут.")
        case .restoreUnsuccessful:
            return Text("Если вы уверены, что у вас есть действующая подписка, напишите на почту me@lisindmitriy.me.")
        case .restoreSuccessful:
            return Text("Действующая подписка успешно восстановлена.")
        }
    }
    
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
                Button(action: buyMonthSubscription) {
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
                                Text("75,00 ₽")
                                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            }
                        }
                    }
                }.padding(.trailing, 4)
                Button(action: buyAnnualSubscription) {
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
                                Text("699,00 ₽")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }.padding(.leading, 4)
            }
            .padding(.top, 8)
            .padding(.horizontal)
            HStack {
                Button(action: restoreSubscription) {
                    Text("Восстановить платеж")
                        .font(.footnote)
                        .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                }
                Text("|")
                    .font(.footnote)
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                Button(action: {}) {
                    Text("Политика")
                        .font(.footnote)
                        .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                }
                Text("|")
                    .font(.footnote)
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                Button(action: {}) {
                    Text("Правила")
                        .font(.footnote)
                        .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                }
            }.padding(.vertical)
        }
        .onAppear(perform: fetchProduct)
        .alert(isPresented: $showAlertSubscription) {
            Alert(title: titleAlert, message: messageAlert, dismissButton: .default(Text("Закрыть")))
        }
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
