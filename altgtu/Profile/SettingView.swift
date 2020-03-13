//
//  SettingView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Instabug
import Purchases
import PartialSheet
import KingfisherSwiftUI

struct SettingView: View {
    
    @State private var isShowingModalViewImage: Bool = false
    @State private var isShowingModalViewUnsplash: Bool = false
    @State private var showActionSheetImage: Bool = false
    @State private var showActionSheetUnsplash: Bool = false
    @State private var showPartialSheet: Bool = false
    @State private var showSubcriptionSheet: Bool = false
    @State private var subscribeApplication: Bool = false
    @State private var firebaseServiceStatus: FirebaseServiceStatus = .normal
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionStore: SessionStore
    
    @ObservedObject var notificationStore: NotificationStore = NotificationStore.shared
    @ObservedObject var imageCacheStore: ImageCacheStore = ImageCacheStore.shared
    @ObservedObject var purchasesStore: PurchasesStore = PurchasesStore.shared
    @ObservedObject var pickerStore: PickerStore = PickerStore.shared
    
    private var appVersionView: some View {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return Text("Версия: \(version) (\(build))")
        } else {
            return Text("#chad")
        }
    }
    
    private let purchasesDataHour: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    private let purchasesDataDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    private let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"

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
            UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController?.presentedViewController?.present(
                UIActivityViewController(activityItems: ["Удобное расписание в приложение АлтГТУ!", URL(string: "https://apps.apple.com/ru/app/altgtu/id1481944453")!], applicationActivities: nil), animated: true, completion: nil
            )
        }
    }
    
    private func openSubscription() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL)
            else {
                return
        }
        UIApplication.shared.open(settingsURL)
    }
    
    var footerNotification: Text {
        switch notificationStore.enabled {
        case .denied:
            return Text("Чтобы активировать уведомления нажмите на кнопку \"Включить уведомления\", после чего активируйте уведомления в настройках.")
        case .notDetermined:
            return Text("Чтобы активировать уведомления нажмите на кнопку \"Включить уведомления\".")
        default:
            return Text("Здесь настраивается время отсрочки уведомлений от начала пары.")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if !purchasesStore.purchasesInfo!.activeSubscriptions.isEmpty {
                        HStack {
                            Image(systemName: "plus.app.fill")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Button(action: openSubscription) {
                                VStack(alignment: .leading) {
                                    Text("Отменить подписку")
                                        .foregroundColor(.primary)
                                    if purchasesStore.purchasesSameDay {
                                        Text("Подписка продлится: Сегодня, \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: purchasesDataHour)")
                                            .font(.system(size: 11))
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("Подписка продлится: \(purchasesStore.purchasesInfo!.expirationDate(forEntitlement: "altgtu")!, formatter: purchasesDataDay)")
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
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
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
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.rValue, in: 0.0...255.0)
                            .accentColor(Color.red.opacity(sessionStore.rValue / 255.0))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.gValue, in: 0.0...255.0)
                            .accentColor(Color.green.opacity(sessionStore.gValue / 255.0))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.bValue, in: 0.0...255.0)
                            .accentColor(Color.blue.opacity(sessionStore.bValue / 255.0))
                        Image(systemName: "b.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    ZStack {
                        Rectangle()
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .frame(height: 60)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        HStack {
                            Spacer(minLength: 10)
                            Text("R:\(Int(sessionStore.rValue))")
                            Text("G:\(Int(sessionStore.gValue))")
                                .padding(.horizontal, 20)
                            Text("B:\(Int(sessionStore.bValue))")
                            Spacer(minLength: 10)
                        }
                        .font(.custom("Futura", size: 24))
                        .foregroundColor(.white)
                    }.padding(.vertical)
                    Toggle(isOn: $sessionStore.darkThemeOverride) {
                        HStack {
                            Image(systemName: "moon.circle")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("Темная тема")
                        }
                    }
                    HStack {
                        Image(systemName: "app")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Изменить иконку") {
                            self.showPartialSheet = true
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "map")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Изменить обложку") {
                            if self.sessionStore.choiseTypeBackroundProfile {
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
                                    self.sessionStore.choiseTypeBackroundProfile = false
                                }, .cancel()
                            ])
                        }
                        .sheet(isPresented: $isShowingModalViewUnsplash, onDismiss: {
                            self.sessionStore.setUnsplashImageForProfileBackground()
                        }, content: {
                            UnsplashImagePicker(unsplashImage: self.$sessionStore.imageFromUnsplashPicker)
                                .accentColor(Color(red: self.sessionStore.rValue/255.0, green: self.sessionStore.gValue/255.0, blue: self.sessionStore.bValue/255.0, opacity: 1.0))
                                .edgesIgnoringSafeArea(.bottom)
                        })
                    }
                }
                Section(header: Text("Личные данные").bold(), footer: Text("Здесь вы можете отредактировать ваши личные данные, их могут видеть другие пользователи.")) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        TextField("Фамилия", text: $sessionStore.lastname)
                    }
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        TextField("Имя", text: $sessionStore.firstname)
                    }
                    DatePicker(selection: $sessionStore.dateBirthDay, displayedComponents: [.date], label: {
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("Дата рождения")
                        }
                    })
                    HStack {
                        Image(systemName: "photo")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Изменить фотографию") {
                            self.showActionSheetImage = true
                        }
                        .foregroundColor(.primary)
                        .actionSheet(isPresented: $showActionSheetImage) {
                            ActionSheet(title: Text("Изменение фотографии"), message: Text("Скорость, с которой отобразиться новая фотография в профиле напрямую зависит от размера выбранной вами фотографии."), buttons: [
                                .default(Text("Сделать фотографию")) {
                                    self.selectedSourceType = .camera
                                    self.isShowingModalViewImage = true
                                }, .default(Text("Выбрать фотографию")) {
                                    self.selectedSourceType = .photoLibrary
                                    self.isShowingModalViewImage = true
                                }, .destructive(Text("Удалить фотографию")) {
                                    self.sessionStore.urlImageProfile = self.deletedUrlImageProfile
                                }, .cancel()
                            ])
                        }
                        .sheet(isPresented: $isShowingModalViewImage, onDismiss: {
                            self.sessionStore.uploadProfileImageToStorage()
                        }, content: {
                            ImagePicker(imageFromPicker: self.$sessionStore.imageProfile, selectedSourceType: self.$selectedSourceType)
                                .accentColor(Color(red: self.sessionStore.rValue/255.0, green: self.sessionStore.gValue/255.0, blue: self.sessionStore.bValue/255.0, opacity: 1.0))
                                .edgesIgnoringSafeArea(.bottom)
                        })
                    }
                }
                Section(header: Text("Уведомления").bold(), footer: footerNotification) {
                    if notificationStore.enabled == .authorized {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Button("Выключить уведомления") {
                                self.openSettings()
                            }.foregroundColor(.primary)
                        }
                        Stepper(value: $sessionStore.notifyMinute, in: 5...30) {
                            HStack {
                                Image(systemName: "timer")
                                    .frame(width: 24)
                                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                                Text("\(sessionStore.notifyMinute) мин")
                            }
                        }
                    }
                    if notificationStore.enabled == .notDetermined {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Button("Включить уведомления") {
                                self.notificationStore.requestPermission()
                            }.foregroundColor(.primary)
                        }
                    }
                    if notificationStore.enabled == .denied {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Button("Включить уведомления") {
                                self.openSettings()
                            }.foregroundColor(.primary)
                        }
                    }
                }
                Section(header: Text("Факультет и группа").bold(), footer: Text("Укажите свой факультет и группу, эти параметры влияют на расписание занятий.")) {
                    Picker(selection: $pickerStore.choiseFaculty, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Факультет")
                    }) {
                        ForEach(0 ..< pickerStore.facultyModel.count, id: \.self) {
                            Text(self.pickerStore.facultyModel[$0].name)
                        }
                    }.lineLimit(1)
                    Picker(selection: $pickerStore.choiseGroup, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Группа")
                    }) {
                        ForEach(0 ..< pickerStore.groupModel.count, id: \.self) {
                            Text(self.pickerStore.groupModel[$0].name)
                        }
                    }.lineLimit(1)
                }
                Section(header: Text("Безопасность").bold(), footer: Text("Здесь вы можете изменить способы авторизации, а также установить параметры доступа к приложению.")) {
                    NavigationLink(destination: BioAndCodeSecure().environmentObject(sessionStore)) {
                        HStack {
                            Image(systemName: "faceid")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("Код-пароль и Face ID")
                            Spacer()
                            Text(sessionStore.boolCodeAccess == true ? "Вкл" : "Выкл")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink(destination: LinkedAccounts().environmentObject(sessionStore)) {
                        HStack {
                            Image(systemName: "list.dash")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("Управление аккаунтами")
                        }
                    }
                }
                Section(header: Text("Кэш изображений").bold(), footer: Text("Если приложение занимает слишком много места, очистка кэша изображений поможет решить эту проблему.")) {
                    ZStack {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color(red: self.sessionStore.rValue/255.0, green: self.sessionStore.gValue/255.0, blue: self.sessionStore.bValue/255.0, opacity: 0.3))
                                Rectangle()
                                    .frame(width: (CGFloat(self.imageCacheStore.sizeImageCache) / CGFloat(self.imageCacheStore.sizeLimitImageCache)) * geometry.size.width, height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color(red: self.sessionStore.rValue/255.0, green: self.sessionStore.gValue/255.0, blue: self.sessionStore.bValue/255.0, opacity: 1.0))
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
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Очистить кэш изображений") {
                            self.imageCacheStore.clearImageCache()
                        }.foregroundColor(.primary)
                    }
                }
                Section(header: Text("Другое").bold(), footer: Text("Если в приложение возникают ошибки или вам не хватает какой-нибудь функции, нажмите на кнопку \"Сообщить об ошибке\".")) {
                    NavigationLink(destination: Changelog()) {
                        Image(systemName: "wand.and.stars.inverse")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Что нового?")
                    }
                    NavigationLink(destination: License()) {
                        Image(systemName: "doc.plaintext")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Лицензии")
                    }
                    HStack {
                        Image(systemName: "star")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
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
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Поделиться") {
                            self.showShareView()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "ant")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Сообщить об ошибке") {
                            Instabug.show()
                        }.foregroundColor(.primary)
                    }
                }
                Section {
                    Button(action: {
                        print("Подробнее")
                    }) {
                        HStack {
                            Spacer()
                            VStack {
                                Text("Create with ❤️ by Lisin Dmitriy")
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
            .environment(\.horizontalSizeClass, .regular)
            .onAppear(perform: startSettingView)
            .navigationBarTitle(Text("Настройки"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Закрыть")
                    .bold()
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
            })
        }
        .accentColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
        .partialSheet(presented: $showPartialSheet, backgroundColor: Color(UIColor.secondarySystemBackground)) {
            ChangeIcons()
        }
    }
}

enum FirebaseServiceStatus {
    case normal
    case problem
    case failure
    case loading
}
