//
//  SettingView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 28.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import StoreKit
import Instabug
import PartialSheet
import KingfisherSwiftUI

struct SettingView: View {
    
    @State private var showAlertCache: Bool = false
    @State private var isShowingModalViewImage: Bool = false
    @State private var isShowingModalViewUnsplash: Bool = false
    @State private var showActionSheetImage: Bool = false
    @State private var showActionSheetUnsplash: Bool = false
    @State private var showPartialSheet: Bool = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionStore: SessionStore
    
    @ObservedObject var notification: NotificationStore = NotificationStore.shared
    @ObservedObject var imageCache: ImageCacheStore = ImageCacheStore.shared
    @ObservedObject var picker: PickerStore = PickerStore.shared
    
    let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
    
    func startSettingView() {
        imageCache.calculateImageCache()
        notification.refreshNotificationStatus()
        if imageCache.sizeLimitImageCache == 0 {
            imageCache.setCacheSizeLimit()
        }
        if picker.facultyModel.isEmpty {
            picker.loadPickerFaculty()
        }
        if picker.groupModel.isEmpty {
            picker.loadPickerGroup()
        }
    }
    
    private func showShareView() {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController?.presentedViewController?.present(
                UIActivityViewController(activityItems: ["Удобное расписание в приложение АлтГТУ!", URL(string: "https://apps.apple.com/ru/app/altgtu/id1481944453")!], applicationActivities: nil), animated: true, completion: nil
            )
        }
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL)
            else {
                return
        }
        UIApplication.shared.open(settingsURL)
    }
    
    var footerNotification: some View {
        switch notification.enabled {
        case .denied:
            return Text("Чтобы активировать уведомления перейдите в настройки.")
        case .notDetermined:
            return Text("Чтобы активировать уведомления перейдите в настройки.")
        default:
            return Text("Здесь настраивается время отсрочки уведомлений от начала пары.")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.rValue, in: 0.0...255.0)
                            .accentColor(Color.red.opacity(sessionStore.rValue / 255.0))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(Color.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.gValue, in: 0.0...255.0)
                            .accentColor(Color.green.opacity(sessionStore.gValue / 255.0))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(Color.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $sessionStore.bValue, in: 0.0...255.0)
                            .accentColor(Color.blue.opacity(sessionStore.bValue / 255.0))
                        Image(systemName: "b.circle.fill")
                            .foregroundColor(Color.blue)
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
                        .font(Font.custom("Futura", size: 24))
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
                        Image(systemName: "app.badge")
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
                            self.showActionSheetUnsplash = true
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
                    }
                }
                Section(header: Text("Уведомления").bold(), footer: footerNotification) {
                    if notification.enabled == .authorized {
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
                    if notification.enabled == .notDetermined {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Button("Включить уведомления") {
                                self.notification.requestPermission()
                            }.foregroundColor(.primary)
                        }
                    }
                    if notification.enabled == .denied {
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
                    Picker(selection: $sessionStore.choiseFaculty, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Факультет")
                    }) {
                        ForEach(0 ..< picker.facultyModel.count, id: \.self) {
                            Text(self.picker.facultyModel[$0].name)
                        }
                    }.lineLimit(1)
                    Picker(selection: $sessionStore.choiseGroup, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Группа")
                    }) {
                        ForEach(0 ..< picker.groupModel.count, id: \.self) {
                            Text(self.picker.groupModel[$0].name)
                        }
                    }.lineLimit(1)
                }
                Section(header: Text("Новости").bold(), footer: Text("Укажите более подходящую тему новостей для вас, которые будут отображаться в разделе \"Сегодня\" по умолчанию.")) {
                    Picker(selection: $sessionStore.choiseNews, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Тема")
                    }) {
                        ForEach(0 ..< sessionStore.news.count, id: \.self) {
                            Text(self.sessionStore.news[$0])
                        }
                    }
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
                        Image(systemName: "list.dash")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Связанные аккаунты")
                    }
                    if sessionStore.userTypeAuth == .email {
                        NavigationLink(destination: ChangeEmail()
                            .environmentObject(sessionStore)
                        ) {
                            Image(systemName: "envelope")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("Изменить эл.почту")
                        }
                        NavigationLink(destination: ChangePassword()
                            .environmentObject(sessionStore)
                        ) {
                            Image(systemName: "lock")
                                .frame(width: 24)
                                .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            Text("Изменить пароль")
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
                                    .frame(width: (CGFloat(self.imageCache.sizeImageCache) / CGFloat(self.imageCache.sizeLimitImageCache)) * geometry.size.width, height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color(red: self.sessionStore.rValue/255.0, green: self.sessionStore.gValue/255.0, blue: self.sessionStore.bValue/255.0, opacity: 1.0))
                                    .animation(.linear)
                                HStack {
                                    Spacer()
                                    Text("\(self.imageCache.sizeImageCache) MB / \(self.imageCache.sizeLimitImageCache) MB")
                                        .foregroundColor(.white)
                                        .font(Font.custom("Futura", size: 24))
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
                            self.imageCache.clearImageCache()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                self.showAlertCache = true
                            }
                        }.foregroundColor(.primary)
                    }
                }
                Section(header: Text("Информация").bold()) {
                    NavigationLink(destination: License()) {
                        Image(systemName: "doc.plaintext")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Лицензии")
                    }
                    NavigationLink(destination: Changelog()) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Список изменений")
                    }
                    NavigationLink(destination: Privacy()) {
                        Image(systemName: "lock.shield")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Политика конфиденциальности")
                    }
                    NavigationLink(destination: InfoApp()) {
                        Image(systemName: "info.circle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("О приложении")
                    }
                }
                Section(header: Text("Другое").bold()) {
                    HStack {
                        Image(systemName: "star")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Button("Оценить") {
                            SKStoreReviewController.requestReview()
                        }.foregroundColor(.primary)
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
                    NavigationLink(destination: DeleteUser()) {
                        Image(systemName: "flame")
                            .frame(width: 24)
                            .foregroundColor(.red)
                        Text("Удалить аккаунт")
                            .foregroundColor(.red)
                    }
                }
            }
            .environment(\.horizontalSizeClass, .regular)
            .onAppear(perform: startSettingView)
            .sheet(isPresented: $isShowingModalViewImage, onDismiss: {
                self.sessionStore.uploadProfileImageToStorage()
            }, content: {
                ImagePicker(imageFromPicker: self.$sessionStore.imageProfile, selectedSourceType: self.$selectedSourceType)
                    .accentColor(Color(red: self.sessionStore.rValue/255.0, green: self.sessionStore.gValue/255.0, blue: self.sessionStore.bValue/255.0, opacity: 1.0))
                    .edgesIgnoringSafeArea(.bottom)
            })
            .alert(isPresented: $showAlertCache) {
                Alert(title: Text("Успешно!"), message: Text("Кэш фотографий успешно очищен."), dismissButton: .default(Text("Закрыть")))
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Готово")
                    .bold()
                    .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
            })
        }
        .accentColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
        .partialSheet(presented: $showPartialSheet, backgroundColor: colorScheme == .dark ? .darkThemeBackground : .white) {
            ChangeIcons()
        }
    }
}
