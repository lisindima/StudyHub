//
//  SubscriptionSplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 16.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Purchases

struct SubscriptionSplashScreen: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    func fetchProduct() {
        Purchases.shared.offerings { (offerings, error) in
            if let packages = offerings?.current?.availablePackages {
                print(packages)
            }
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
                Button(action: {}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 0.2))
                            .frame(width: 150, height: 72)
                        VStack {
                            Text("Ежемесячно")
                                .bold()
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("75,00 ₽")
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        }
                    }
                }.padding(.trailing, 8)
                Button(action: {}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            .frame(width: 150, height: 72)
                        VStack {
                            Text("Ежегодно")
                                .bold()
                                .foregroundColor(.white)
                            Text("699,00 ₽")
                                .foregroundColor(.white)
                        }
                    }
                }.padding(.leading, 8)
            }.padding(.top)
            Button(action: {}) {
                Text("Восстановить платеж")
                    .font(.footnote)
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
            }.padding(.vertical)
        }.onAppear(perform: fetchProduct)
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
            InformationDetailView(title: "Поддержка", subTitle: "Оформляя подписку вы поддерживаете разработчика и позволяете развиваться приложению.", imageName: "heart")
            InformationDetailView(title: "Оформление", subTitle: "Открывается возможность менять цвета акцентов в приложение, менять иконку приложения и тд.", imageName: "app")
            InformationDetailView(title: "Поддержка", subTitle: "Оформляя подписку вы поддерживаете разработчика и позволяете развиваться приложению.", imageName: "heart")
            InformationDetailView(title: "Оформление", subTitle: "Открывается возможность менять цвета акцентов в приложение, менять иконку приложения и тд.", imageName: "app")
            InformationDetailView(title: "Поддержка", subTitle: "Оформляя подписку вы поддерживаете разработчика и позволяете развиваться приложению.", imageName: "heart")
            InformationDetailView(title: "Оформление", subTitle: "Открывается возможность менять цвета акцентов в приложение, менять иконку приложения и тд.", imageName: "app")
        }.padding(.horizontal)
    }
}

struct SubscriptionSplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionSplashScreen()
    }
}
