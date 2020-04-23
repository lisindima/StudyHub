//
//  SettingView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import SPAlert
import MessageUI
import KingfisherSwiftUI

struct SettingView: View {
    
    @State private var isShowingModalViewUnsplash: Bool = false
    @State private var showActionSheetUnsplash: Bool = false
    @State private var showActionSheetMailFeedback: Bool = false
    @State private var showSubcriptionSheet: Bool = false
    @State private var subscribeApplication: Bool = false
    @State private var firebaseServiceStatus: FirebaseServiceStatus = .normal
    @State private var mailSubject: String = ""
    
    @Binding var showPartialSheet: Bool
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var notificationStore: NotificationStore = NotificationStore.shared
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var imageCacheStore: ImageCacheStore = ImageCacheStore.shared
    @ObservedObject private var purchasesStore: PurchasesStore = PurchasesStore.shared
    @ObservedObject private var pickerStore: PickerStore = PickerStore.shared
    @ObservedObject private var dateStore: DateStore = DateStore.shared
    
    private var appVersionView: some View {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return Text("Версия: \(version) (\(build))")
        } else {
            return Text("#chad")
        }
    }

    private func startSettingView() {
        imageCacheStore.calculateImageCache()
        notificationStore.refreshNotificationStatus()
        purchasesStore.purchasesIsDateInToday()
        if imageCacheStore.sizeLimitImageCache == 0 {
            imageCacheStore.setCacheSizeLimit()
        }
        if pickerStore.facultyModel.isEmpty {
            pickerStore.loadPickerFaculty()
            pickerStore.getDataFromDatabaseListenPicker()
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
                MailFeedback(mailSubject: self.$mailSubject)
                    .edgesIgnoringSafeArea(.bottom)
                    .accentColor(Color.rgb(red: self.sessionStore.userData.rValue, green: self.sessionStore.userData.gValue, blue: self.sessionStore.userData.bValue))
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
                                    Text("Отменить подписку")
                                        .foregroundColor(.primary)
                                    if purchasesStore.purchasesSameDay {
                                        Text("Подписка продлится: Сегодня, \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: dateStore.dateHour)")
                                            .font(.system(size: 11))
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Подписка продлится: \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: dateStore.dateDay)")
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
                                self.showSubcriptionSheet = true
                            }
                            .foregroundColor(.primary)
                            .sheet(isPresented: $showSubcriptionSheet) {
                                SubscriptionSplashScreen()
                                    .environmentObject(self.sessionStore)
                            }
                        }
                    }
                    if firebaseServiceStatus == .normal {
                        HStack {
                            Image(systemName: "icloud")
                                .frame(width: 24)
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Синхронизация работает")
                                Text("Все сервисы работают в обычном режиме.")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else if firebaseServiceStatus == .problem {
                        HStack {
                            Image(systemName: "exclamationmark.icloud")
                                .frame(width: 24)
                                .foregroundColor(.yellow)
                            VStack(alignment: .leading) {
                                Text("Наблюдаются неполадки")
                                Text("Cихронизация может занять больше времени.")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else if firebaseServiceStatus == .failure {
                        HStack {
                            Image(systemName: "xmark.icloud")
                                .frame(width: 24)
                                .foregroundColor(.red)
                            VStack(alignment: .leading) {
                                Text("Синхронизация не работает")
                                Text("Данные пользователей сохраняются локально.")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else if firebaseServiceStatus == .loading {
                       HStack {
                            ActivityIndicator(styleSpinner: .medium)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Загрузка")
                                Text("Проверяем работоспособность сервера.")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Section(header: Text("Оформление").fontWeight(.bold), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.userData.rValue, in: 0.0...255.0)
                            .accentColor(Color.red.opacity(sessionStore.userData.rValue / 255.0))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.userData.gValue, in: 0.0...255.0)
                            .accentColor(Color.green.opacity(sessionStore.userData.gValue / 255.0))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.userData.bValue, in: 0.0...255.0)
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
                    #if !targetEnvironment(macCatalyst)
                    HStack {
                        Image(systemName: "app")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Изменить иконку") {
                            self.showPartialSheet = true
                        }.foregroundColor(.primary)
                    }
                    #endif
                    HStack {
                        Image(systemName: "map")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Изменить обложку") {
                            if self.sessionStore.userData.choiseTypeBackroundProfile {
                                self.showActionSheetUnsplash = true
                            } else {
                                self.isShowingModalViewUnsplash = true
                            }
                        }
                        .foregroundColor(.primary)
                        .actionSheet(isPresented: $showActionSheetUnsplash) {
                            ActionSheet(title: Text("Изменение обложки"), message: Text("Здесь вы можете поменять внешний вид обложки в своем профиле."), buttons: [
                                .default(Text("Выбрать из Unsplash")) {
                                    self.isShowingModalViewUnsplash = true
                                }, .destructive(Text("Удалить обложку")) {
                                    self.sessionStore.userData.choiseTypeBackroundProfile = false
                                }, .cancel()
                            ])
                        }
                        .sheet(isPresented: $isShowingModalViewUnsplash) {
                            UnsplashImagePicker()
                                .accentColor(Color.rgb(red: self.sessionStore.userData.rValue, green: self.sessionStore.userData.gValue, blue: self.sessionStore.userData.bValue))
                                .edgesIgnoringSafeArea(.bottom)
                        }
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
                Section(header: Text("Безопасность").fontWeight(.bold), footer: Text("Здесь вы можете изменить способы авторизации, а также удалить аккаунт.")) {
                    NavigationLink(destination: BioAndCodeSecure()) {
                        HStack {
                            Image(systemName: "faceid")
                                .frame(width: 24)
                                .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            Text("Код-пароль и Face ID")
                            Spacer()
                            Text(sessionStore.userData.boolCodeAccess ? "Вкл" : "Выкл")
                                .foregroundColor(.secondary)
                        }
                    }
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
                                    .foregroundColor(Color.rgb(red: self.sessionStore.userData.rValue, green: self.sessionStore.userData.gValue, blue: self.sessionStore.userData.bValue))
                                    .opacity(0.2)
                                Rectangle()
                                    .frame(width: (CGFloat(self.imageCacheStore.sizeImageCache) / CGFloat(self.imageCacheStore.sizeLimitImageCache)) * geometry.size.width, height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color.rgb(red: self.sessionStore.userData.rValue, green: self.sessionStore.userData.gValue, blue: self.sessionStore.userData.bValue))
                                    .animation(.linear)
                                HStack {
                                    Spacer()
                                    Text("\(self.imageCacheStore.sizeImageCache) MB / \(self.imageCacheStore.sizeLimitImageCache) MB")
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
                            self.imageCacheStore.clearImageCache()
                        }.foregroundColor(.primary)
                    }
                }
                Section(header: Text("Другое").fontWeight(.bold), footer: Text("Если в приложение возникают ошибки или вам не хватает какой-нибудь функции, нажмите на кнопку \"Сообщить об ошибке\".")) {
                    NavigationLink(destination: Changelog()) {
                        Image(systemName: "wand.and.stars.inverse")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Text("Что нового?")
                    }
                    NavigationLink(destination: License()) {
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
                            self.showShareView()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "ant")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        Button("Сообщить об ошибке") {
                            if MFMailComposeViewController.canSendMail() {
                                self.showActionSheetMailFeedback = true
                            } else {
                                SPAlert.present(title: "Не установлено приложение \"Почта\".", message: "Установите его из App Store." , preset: .error)
                            }
                        }
                        .foregroundColor(.primary)
                        .actionSheet(isPresented: $showActionSheetMailFeedback) {
                            ActionSheet(title: Text("Выберите вариант"), message: Text("Пожалуйста, выберите правильный вариант, на основе того, что вы хотите сообщить."), buttons: [
                                .default(Text("Запросить функцию")) {
                                    self.mailSubject = "Запрос функций"
                                    self.showMailView()
                                }, .default(Text("Сообщить об ошибке")) {
                                    self.mailSubject = "Сообщение об ошибке"
                                    self.showMailView()
                                }, .cancel()
                            ])
                        }
                    }
                }
                Section {
                    Button(action: {
                        print("Подробнее")
                    }) {
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
            }
            .onAppear(perform: startSettingView)
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Настройки", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Закрыть")
                    .bold()
            })
        }
        .accentColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

enum FirebaseServiceStatus {
    case normal, problem, failure, loading
}
