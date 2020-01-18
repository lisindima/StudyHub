//
//  ContentView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import URLImage
import StoreKit

struct ProfileView: View {
    
    @State private var showAlertCache: Bool = false
    @State private var showSettingModal: Bool = false
    @State private var isShowingModalView: Bool = false
    @State private var isShowingModalViewUnsplash: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var showQRReader: Bool = false
    @State private var showActionSheetImage: Bool = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var pickerAPI: PickerAPI
    @EnvironmentObject var nfc: NFCStore
    
    @ObservedObject var notification = NotificationStore.shared
    
    let currentUser = Auth.auth().currentUser!
    var elements: [GroupModelElement] = [GroupModelElement]()
    let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
    
    private func tappedShare() {
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
                            .foregroundColor(.accentColor)
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
                            .foregroundColor(.accentColor)
                        Button("Изменить обложку") {
                            self.isShowingModalViewUnsplash = true
                        }
                        .foregroundColor(.primary)
                        .sheet(isPresented: $isShowingModalViewUnsplash, onDismiss: {
                            print("UNSPLASH")
                            //self.session.setUnsplashImageForProfileBackground()
                        }, content: {
                            UnsplashImagePicker()
                                .edgesIgnoringSafeArea(.bottom)
                        })
                    }
                    Toggle(isOn: $session.darkThemeOverride) {
                        HStack {
                            Image(systemName: "moon.circle")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
                            Text("Темная тема")
                        }
                    }
                }
                Section(header: Text("Личные данные").bold(), footer: Text("Здесь вы можете отредактировать ваши личные данные, их могут видеть другие пользователи.")) {
                    TextField("Фамилия", text: $session.lastname)
                    TextField("Имя", text: $session.firstname)
                    DatePicker(selection: $session.dateBirthDay, displayedComponents: [.date], label: {
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
                            Text("Дата рождения")
                        }
                    })
                    HStack {
                        Image(systemName: "photo")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Button("Изменить фотографию") {
                            self.showActionSheetImage = true
                        }.actionSheet(isPresented: $showActionSheetImage) {
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
                        }.foregroundColor(.primary)
                    }
                }
                Section(header: Text("Уведомления").bold(), footer: footerNotification) {
                    if notification.enabled == .authorized {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
                            Button("Выключить уведомления") {
                                self.openSettings()
                            }.foregroundColor(.primary)
                        }
                        Stepper(value: $session.notifyMinute, in: 5...30) {
                            HStack {
                                Image(systemName: "timer")
                                    .frame(width: 24)
                                    .foregroundColor(.accentColor)
                                Text("\(session.notifyMinute) мин")
                            }
                        }
                    }
                    if notification.enabled == .notDetermined {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
                            Button("Включить уведомления") {
                                self.notification.requestPermission()
                            }.foregroundColor(.primary)
                        }
                    }
                    if notification.enabled == .denied {
                        HStack {
                            Image(systemName: "bell")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
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
                            .foregroundColor(.accentColor)
                        Text("Выбранный факультет")
                    }) {
                        ForEach(0 ..< session.faculty.count, id: \.self) {
                            Text(self.session.faculty[$0])
                        }
                    }
                    Picker(selection: $session.choiseGroup, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Выбранная группа")
                    }) {
                        ForEach(0 ..< elements.count, id: \.self) {
                            Text(self.elements[$0].name)
                        }
                    }
                }
                Section(header: Text("Новости").bold(), footer: Text("Укажите более подходящую тему новостей для вас, которые будут отображаться в разделе \"Сегодня\" по умолчанию.")) {
                    Picker(selection: $session.choiseNews, label: HStack {
                        Image(systemName: "list.bullet.below.rectangle")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Выбранная тема")
                    }) {
                        ForEach(0 ..< session.news.count, id: \.self) {
                            Text(self.session.news[$0])
                        }
                    }
                }
                Section(header: Text("Безопасность").bold(), footer: Text("Здесь вы можете изменить способы авторизации, а также установить параметры доступа к приложению.")) {
                    if session.userTypeAuth == .email {
                        NavigationLink(destination: ChangeEmail()
                            .environmentObject(SessionStore())
                        ) {
                            Image(systemName: "envelope")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
                            Text("Изменить эл.почту")
                        }
                        NavigationLink(destination: ChangePassword()
                            .environmentObject(SessionStore())
                        ) {
                            Image(systemName: "lock")
                                .frame(width: 24)
                                .foregroundColor(.accentColor)
                            Text("Изменить пароль")
                        }
                    }
                    NavigationLink(destination: PinSetting(boolCodeAccess: $session.boolCodeAccess, pinCodeAccess: $session.pinCodeAccess, biometricAccess: $session.biometricAccess)) {
                        Image(systemName: "faceid")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Код-пароль и Face ID")
                    }
                    NavigationLink(destination: SetAuth()) {
                        Image(systemName: "list.dash")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Вариаты авторизации")
                    }
                }
                Section(header: Text("Информация").bold()) {
                    NavigationLink(destination: License()) {
                        Image(systemName: "doc.plaintext")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Лицензии")
                    }
                    NavigationLink(destination: Changelog()) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Список изменений")
                    }
                    NavigationLink(destination: Privacy()) {
                        Image(systemName: "lock.shield")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("Политика конфиденциальности")
                    }
                    NavigationLink(destination: InfoApp()) {
                        Image(systemName: "info.circle")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Text("О приложении")
                    }
                }
                Section(header: Text("Другое").bold(), footer: Text("Если приложение занимает слишком много места, очистка кэша изображений поможет его освободить.")) {
                    HStack {
                        Image(systemName: "star")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Button("Оценить") {
                            SKStoreReviewController.requestReview()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Button("Поделиться") {
                            self.tappedShare()
                        }.foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "trash")
                            .frame(width: 24)
                            .foregroundColor(.accentColor)
                        Button("Очистить кэш изображений") {
                            URLImageService.shared.cleanFileCache()
                            URLImageService.shared.resetFileCache()
                            self.showAlertCache = true
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
            .onAppear(perform: notification.refreshNotificationStatus)
            .sheet(isPresented: $isShowingModalView, onDismiss: {
                self.session.uploadProfileImageToStorage()
            }, content: {
                ImagePicker(imageFromPicker: self.$session.imageProfile, selectedSourceType: self.$selectedSourceType)
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
                    .foregroundColor(.accentColor)
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
                        URLImage(URL(string: "https://images.unsplash.com/photo-1578241561880-0a1d5db3cb8a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80")!, incremental: false, expireAfter: Date(timeIntervalSinceNow: 3600.0), placeholder: { _ in
                            Rectangle()
                                .foregroundColor(self.colorScheme == .light ? .white : .black)
                                .edgesIgnoringSafeArea(.top)
                                .frame(height: 130)
                        },
                                 content: { proxy in
                                    proxy.image
                                        .resizable()
                                        .edgesIgnoringSafeArea(.top)
                                        .frame(height: 130)
                                        .aspectRatio(contentMode: .fit)
                        })
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
            }, content: {
                self.sliderModalPresentation
            })
        }
        .accentColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
