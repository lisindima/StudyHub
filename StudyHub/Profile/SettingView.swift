//
//  SettingView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 28.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import KingfisherSwiftUI
import MessageUI
import SPAlert
import SwiftUI

struct SettingView: View {
    @State private var showActionSheetMailFeedback: Bool = false
    @State private var showSubcriptionSheet: Bool = false
    @State private var subscribeApplication: Bool = false
    @State private var mailSubject: String = ""

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var sessionStore: SessionStore

    @ObservedObject private var notificationStore = NotificationStore.shared
    @ObservedObject private var imageCacheStore = ImageCacheStore.shared
    @ObservedObject private var purchasesStore = PurchasesStore.shared

    private var appVersionView: some View {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            return Text("Версия: \(version) (\(build))")
        } else {
            return Text("")
        }
    }

    private func startSettingView() {
        imageCacheStore.calculateImageCache()
        notificationStore.refreshNotificationStatus()
        purchasesStore.purchasesIsDateInToday()
        if imageCacheStore.sizeLimitImageCache == 0 {
            imageCacheStore.setCacheSizeLimit()
        }
    }

    private func showShareView() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.presentedViewController?.present(
                UIActivityViewController(activityItems: ["Удобное расписание в приложение StudyHub!", URL(string: "https://apps.apple.com/ru/app/altgtu/id1481944453")!], applicationActivities: nil), animated: true, completion: nil
            )
        }
    }

    private func showMailView() {
        DispatchQueue.main.async {
            let mailFeedback = UIHostingController(rootView:
                MailFeedback(mailSubject: $mailSubject)
                    .edgesIgnoringSafeArea(.bottom)
                    .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
            )
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.presentedViewController?.present(
                mailFeedback, animated: true, completion: nil
            )
        }
    }

    private func openSubscription() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    if !purchasesStore.purchasesInfo!.activeSubscriptions.isEmpty {
                        HStack {
                            Image(systemName: "plus.app.fill")
                                .frame(width: 24)
                                .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            Button(action: openSubscription) {
                                VStack(alignment: .leading) {
                                    Text("Управление подпиской")
                                        .foregroundColor(.primary)
                                    if purchasesStore.purchasesSameDay {
                                        Text("Подписка возобновится: Сегодня, \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: dateHour)")
                                            .font(.system(size: 11))
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Подписка возобновится: \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: dateDay)")
                                            .font(.system(size: 11))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "plus.app.fill")
                                .frame(width: 24)
                                .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            Button("Оформить подписку") {
                                showSubcriptionSheet = true
                            }
                            .foregroundColor(.primary)
                            .sheet(isPresented: $showSubcriptionSheet) {
                                SubscriptionSplashScreen()
                                    .environmentObject(sessionStore)
                            }
                        }
                    }
                }
                Section(header: Text("Оформление").fontWeight(.bold), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.userData.rValue, in: 0.0 ... 255.0)
                            .accentColor(Color.red.opacity(sessionStore.userData.rValue / 255.0))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.userData.gValue, in: 0.0 ... 255.0)
                            .accentColor(Color.green.opacity(sessionStore.userData.gValue / 255.0))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.userData.bValue, in: 0.0 ... 255.0)
                            .accentColor(Color.blue.opacity(sessionStore.userData.bValue / 255.0))
                        Image(systemName: "b.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    ZStack {
                        Rectangle()
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .frame(height: 60)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        HStack {
                            Text("R:\(Int(sessionStore.userData.rValue))")
                                .frame(width: 90)
                            Text("G:\(Int(sessionStore.userData.gValue))")
                                .frame(width: 90)
                            Text("B:\(Int(sessionStore.userData.bValue))")
                                .frame(width: 90)
                        }
                        .font(.custom("Futura", size: 24))
                        .foregroundColor(.white)
                    }.padding(.vertical)
                    Toggle(isOn: $sessionStore.userData.darkThemeOverride) {
                        Image(systemName: "moon.circle")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Темная тема")
                    }
                }
                Section(header: Text("Настройки уведомлений").fontWeight(.bold), footer: Text("Здесь вы можете управлять уведомлениями, выбирать именно те, которые вы хотите получать или вовсе отключить все.")) {
                    NavigationLink(destination: NotificationSetting()) {
                        Image(systemName: "bell")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Уведомления")
                        Spacer()
                        Text(notificationStore.enabled == .authorized ? "Вкл" : "Выкл")
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Аккаунт").fontWeight(.bold), footer: Text("Здесь вы можете изменить способы авторизации, а также удалить аккаунт.")) {
                    NavigationLink(destination: SettingAccount()) {
                        Image(systemName: "list.dash")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Настройки аккаунта")
                    }
                }
                Section(header: Text("Кэш изображений").fontWeight(.bold), footer: Text("Если приложение занимает слишком много места, очистка кэша изображений поможет решить эту проблему.")) {
                    ZStack {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                    .opacity(0.2)
                                Rectangle()
                                    .frame(width: (CGFloat(imageCacheStore.sizeImageCache) / CGFloat(imageCacheStore.sizeLimitImageCache)) * geometry.size.width, height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                                    .animation(.linear)
                                HStack {
                                    Spacer()
                                    Text("\(imageCacheStore.sizeImageCache) MB / \(imageCacheStore.sizeLimitImageCache) MB")
                                        .foregroundColor(.white)
                                        .font(.custom("Futura", size: 24))
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(height: 60)
                    .padding(.vertical)
                    HStack {
                        Image(systemName: "trash")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Очистить кэш изображений") {
                            imageCacheStore.clearImageCache()
                        }.foregroundColor(.primary)
                    }
                }
                Section(header: Text("Другое").fontWeight(.bold), footer: Text("Если в приложение возникают ошибки или вам не хватает какой-нибудь функции, нажмите на кнопку \"Сообщить об ошибке\".")) {
                    NavigationLink(destination: Text("Лицензии")) {
                        Image(systemName: "doc.plaintext")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Лицензии")
                    }
                    HStack {
                        Image(systemName: "star")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Оценить") {
                            UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id1481944453?action=write-review")!)
                        }.foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Поделиться") {
                            showShareView()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "ant")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Сообщить об ошибке") {
                            if MFMailComposeViewController.canSendMail() {
                                showActionSheetMailFeedback = true
                            } else {
                                SPAlert.present(title: "Не установлено приложение \"Почта\".", message: "Установите его из App Store.", preset: .error)
                            }
                        }
                        .foregroundColor(.primary)
                        .actionSheet(isPresented: $showActionSheetMailFeedback) {
                            ActionSheet(title: Text("Выберите вариант"), message: Text("Пожалуйста, выберите правильный вариант, на основе того, что вы хотите сообщить."), buttons: [
                                .default(Text("Запросить функцию")) {
                                    mailSubject = "Запрос функций"
                                    showMailView()
                                }, .default(Text("Сообщить об ошибке")) {
                                    mailSubject = "Сообщение об ошибке"
                                    showMailView()
                                }, .cancel(),
                            ])
                        }
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Создано с ❤️ Лисиным Дмитрием")
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                            appVersionView
                                .foregroundColor(.secondary)
                                .font(.system(size: 12))
                        }
                        Spacer()
                    }.padding(.vertical, 5)
                }
            }
            .onAppear(perform: startSettingView)
            .navigationTitle("Настройки")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Закрыть")
                    }
                }
            }
        }
        .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
