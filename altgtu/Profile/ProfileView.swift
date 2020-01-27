//
//  ContentView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import StoreKit
import Firebase
import Instabug
import KingfisherSwiftUI

struct ProfileView: View {
    
    @State private var showAlertCache: Bool = false
    @State private var showSettingModal: Bool = false
    @State private var isShowingModalView: Bool = false
    @State private var isShowingModalViewUnsplash: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var showQRReader: Bool = false
    @State private var showActionSheetImage: Bool = false
    @State private var showActionSheetUnsplash: Bool = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var nfc: NFCStore
    
    @ObservedObject var notification = NotificationStore.shared
    @ObservedObject var imageCache = ImageCacheStore.shared
    @ObservedObject var picker = PickerStore.shared
    
    let currentUser = Auth.auth().currentUser!
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
    
    var sliderModalPresentation: some View {
        NavigationView {
            Form {
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.rValue, in: 0.0...255.0)
                            .accentColor(Color.red.opacity(session.rValue / 255.0))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(Color.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.gValue, in: 0.0...255.0)
                            .accentColor(Color.green.opacity(session.gValue / 255.0))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(Color.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.bValue, in: 0.0...255.0)
                            .accentColor(Color.blue.opacity(session.bValue / 255.0))
                        Image(systemName: "b.circle.fill")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    ZStack {
                        Rectangle()
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .frame(height: 60)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        HStack {
                            Spacer(minLength: 10)
                            Text("R:\(Int(session.rValue))")
                            Text("G:\(Int(session.gValue))")
                                .padding(.horizontal, 20)
                            Text("B:\(Int(session.bValue))")
                            Spacer(minLength: 10)
                        }
                        .font(Font.custom("Futura", size: 24))
                        .foregroundColor(.white)
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "map")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Button("Изменить обложку") {
                            self.showActionSheetUnsplash = true
                        }
                        .foregroundColor(.primary)
                        .actionSheet(isPresented: $showActionSheetUnsplash) {
                            ActionSheet(title: Text("Изменение обложки"), message: Text("Здесь вы можете поменять внешний вид обложки в своем профиле."), buttons: [
                                .default(Text("Выбрать из Unsplash")) {
                                    self.isShowingModalViewUnsplash = true
                                }, .destructive(Text("Удалить обложку")) {
                                    self.session.choiseTypeBackroundProfile = false
                                }, .cancel()
                            ])
                        }
                        .sheet(isPresented: $isShowingModalViewUnsplash, onDismiss: {
                            self.session.setUnsplashImageForProfileBackground()
                        }, content: {
                            UnsplashImagePicker(unsplashImage: self.$session.imageFromUnsplashPicker)
                                .accentColor(Color(red: self.session.rValue/255.0, green: self.session.gValue/255.0, blue: self.session.bValue/255.0, opacity: 1.0))
                                .edgesIgnoringSafeArea(.bottom)
                        })
                    }
                    Toggle(isOn: $session.darkThemeOverride) {
                        HStack {
                            Image(systemName: "moon.circle")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Text("Темная тема")
                        }
                    }
                }
                Section(header: Text("Личные данные").bold(), footer: Text("Здесь вы можете отредактировать ваши личные данные, их могут видеть другие пользователи.")) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        TextField("Фамилия", text: $session.lastname)
                    }
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        TextField("Имя", text: $session.firstname)
                    }
                    DatePicker(selection: $session.dateBirthDay, displayedComponents: [.date], label: {
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Text("Дата рождения")
                        }
                    })
                    HStack {
                        Image(systemName: "photo")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Button("Изменить фотографию") {
                            self.showActionSheetImage = true
                        }
                        .foregroundColor(.primary)
                        .actionSheet(isPresented: $showActionSheetImage) {
                            ActionSheet(title: Text("Изменение фотографии"), message: Text("Скорость, с которой отобразиться новая фотография в профиле напрямую зависит от размера выбранной вами фотографии."), buttons: [
                                .default(Text("Сделать фотографию")) {
                                    self.selectedSourceType = .camera
                                    self.isShowingModalView = true
                                }, .default(Text("Выбрать фотографию")) {
                                    self.selectedSourceType = .photoLibrary
                                    self.isShowingModalView = true
                                }, .destructive(Text("Удалить фотографию")) {
                                    self.session.urlImageProfile = self.deletedUrlImageProfile
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
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Button("Выключить уведомления") {
                                self.openSettings()
                            }.foregroundColor(.primary)
                        }
                        Stepper(value: $session.notifyMinute, in: 5...30) {
                            HStack {
                                Image(systemName: "timer")
                                    .frame(width: 24)
                                    .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                                Text("\(session.notifyMinute) мин")
                            }
                        }
                    }
                    if notification.enabled == .notDetermined {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Button("Включить уведомления") {
                                self.notification.requestPermission()
                            }.foregroundColor(.primary)
                        }
                    }
                    if notification.enabled == .denied {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Button("Включить уведомления") {
                                self.openSettings()
                            }.foregroundColor(.primary)
                        }
                    }
                }
                Section(header: Text("Факультет и группа").bold(), footer: Text("Укажите свой факультет и группу, эти параметры влияют на расписание занятий.")) {
                    Picker(selection: $session.choiseFaculty, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Факультет")
                    }) {
                        ForEach(0 ..< picker.facultyModel.count, id: \.self) {
                            Text(self.picker.facultyModel[$0].name)
                        }
                    }.lineLimit(1)
                    Picker(selection: $session.choiseGroup, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Группа")
                    }) {
                        ForEach(0 ..< picker.groupModel.count, id: \.self) {
                            Text(self.picker.groupModel[$0].name)
                        }
                    }.lineLimit(1)
                }
                Section(header: Text("Новости").bold(), footer: Text("Укажите более подходящую тему новостей для вас, которые будут отображаться в разделе \"Сегодня\" по умолчанию.")) {
                    Picker(selection: $session.choiseNews, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Тема")
                    }) {
                        ForEach(0 ..< session.news.count, id: \.self) {
                            Text(self.session.news[$0])
                        }
                    }
                }
                Section(header: Text("Безопасность").bold(), footer: Text("Здесь вы можете изменить способы авторизации, а также установить параметры доступа к приложению.")) {
                    NavigationLink(destination: BioAndCodeSecure(boolCodeAccess: $session.boolCodeAccess, pinCodeAccess: $session.pinCodeAccess, biometricAccess: $session.biometricAccess)) {
                        HStack {
                            Image(systemName: "faceid")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Text("Код-пароль и Face ID")
                            Spacer()
                            Text(session.boolCodeAccess == true ? "Вкл" : "Выкл")
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink(destination: LinkedAccounts().environmentObject(session)) {
                        Image(systemName: "list.dash")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Связанные аккаунты")
                    }
                    if session.userTypeAuth == .email {
                        NavigationLink(destination: ChangeEmail()
                            .environmentObject(SessionStore())
                        ) {
                            Image(systemName: "envelope")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            Text("Изменить эл.почту")
                        }
                        NavigationLink(destination: ChangePassword()
                            .environmentObject(SessionStore())
                        ) {
                            Image(systemName: "lock")
                                .frame(width: 24)
                                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
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
                                    .foregroundColor(Color(red: self.session.rValue/255.0, green: self.session.gValue/255.0, blue: self.session.bValue/255.0, opacity: 0.3))
                                Rectangle()
                                    .frame(width: (CGFloat(self.imageCache.sizeImageCache) / CGFloat(self.imageCache.sizeLimitImageCache)) * geometry.size.width, height: 60)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .foregroundColor(Color(red: self.session.rValue/255.0, green: self.session.gValue/255.0, blue: self.session.bValue/255.0, opacity: 1.0))
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
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
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
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Лицензии")
                    }
                    NavigationLink(destination: Changelog()) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Список изменений")
                    }
                    NavigationLink(destination: Privacy()) {
                        Image(systemName: "lock.shield")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("Политика конфиденциальности")
                    }
                    NavigationLink(destination: InfoApp()) {
                        Image(systemName: "info.circle")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Text("О приложении")
                    }
                }
                Section(header: Text("Другое").bold()) {
                    HStack {
                        Image(systemName: "star")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Button("Оценить") {
                            SKStoreReviewController.requestReview()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        Button("Поделиться") {
                            self.showShareView()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "ant")
                            .frame(width: 24)
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
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
            .sheet(isPresented: $isShowingModalView, onDismiss: {
                self.session.uploadProfileImageToStorage()
            }, content: {
                ImagePicker(imageFromPicker: self.$session.imageProfile, selectedSourceType: self.$selectedSourceType)
                    .accentColor(Color(red: self.session.rValue/255.0, green: self.session.gValue/255.0, blue: self.session.bValue/255.0, opacity: 1.0))
                    .edgesIgnoringSafeArea(.bottom)
            })
            .alert(isPresented: $showAlertCache) {
                Alert(title: Text("Успешно!"), message: Text("Кэш фотографий успешно очищен."), dismissButton: .default(Text("Закрыть")))
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSettingModal = false
            }) {
                Text("Готово")
                    .bold()
                    .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
            })
        }
        .accentColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if session.choiseTypeBackroundProfile == false {
                        Rectangle()
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 130)
                    } else {
                        KFImage(URL(string: session.setImageForBackroundProfile))
                            .placeholder {
                                Rectangle()
                                    .foregroundColor(colorScheme == .light ? .white : .black)
                                    .edgesIgnoringSafeArea(.top)
                                    .frame(height: 130)
                            }
                            .resizable()
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 130)
                            .aspectRatio(contentMode: .fit)
                    }
                    ZStack {
                        ProfileImage()
                            .offset(y: -120)
                            .padding(.bottom, -130)
                        if session.adminSetting {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(colorScheme == .light ? .white : .black)
                                    .shadow(radius: 10)
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                
                            }.offset(x: 80, y: 25)
                        }
                    }
                    VStack {
                        Text((session.lastname!) + " " + (session.firstname!))
                            .bold()
                            .font(.title)
                        Text(currentUser.email!)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }.padding()
                }
                Spacer()
                /*
                 Button(action: {
                 self.session.showBanner = true
                 self.session.setNotification()
                 self.nfc.readCard()
                 }, label: {
                 Text("Тест")
                 .bold()
                 .foregroundColor(.red)
                 .padding()
                 })
                 */
                Button(action: {
                    self.showActionSheetExit = true
                }, label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .imageScale(.large)
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.red)
                        Text("Выйти")
                            .bold()
                            .foregroundColor(.red)
                    }
                }).padding()
            }
            .navigationBarItems(leading: Button(action: {
                self.showQRReader = true
            }) {
                Image(systemName: "qrcode")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }.sheet(isPresented: $showQRReader, onDismiss: {
                
            }, content: {
                QRReader()
            }), trailing: Button(action: {
                self.showSettingModal = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(.white)
            })
            .actionSheet(isPresented: $showActionSheetExit) {
                ActionSheet(title: Text("Вы уверены, что хотите выйти из этого аккаунта?"), message: Text("Для продолжения использования приложения вам потребуется повторно войти в аккаунт!"), buttons: [.destructive(Text("Выйти")) {
                    self.session.signOut()
                    }, .cancel()
                ])
            }
            .sheet(isPresented: $showSettingModal, onDismiss: {
                self.session.session == nil ? print("Сессии нет, данные не сохраняются") : self.session.updateDataFromDatabase()
                self.session.setInstabugColor()
            }, content: {
                self.sliderModalPresentation
            })
        }
        .accentColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
