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

struct ProfileView: View {
    
    @State private var showActionSheet: Bool = false
    @State private var showAlertCache: Bool = false
    @State private var isPresented: Bool = false
    @State private var isShowingModalView: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var setModalView: Int = 1
    @State private var showActionSheetImage: Bool = false
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var pickerAPI: PickerAPI

    let currentUser = Auth.auth().currentUser!
    var elements: [GroupModelElement] = [GroupModelElement]()
    let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
    
    func test() {
        pickerAPI.loadPickerData()
        print(elements)
    }
    
    var sliderModalPresentation: some View {
        NavigationView {
            Form {
                Section(header: Text("Главное").bold(), footer: Text("Здесь настраивается время отсрочки уведомлений, например, для уведомлений о начале пары.")) {
                    Toggle(isOn: $session.notifyAlertProfile.animation()) {
                            Text("Уведомления")
                    }
                    if session.notifyAlertProfile {
                        Stepper("\(session.notifyMinute) мин", value: $session.notifyMinute, in: 5...30)
                    }
                }
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.rValue, in: 0.0...255.0)
                            .accentColor(Color.red.opacity(session.rValue))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(Color.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.gValue, in: 0.0...255.0)
                            .accentColor(Color.green.opacity(session.gValue))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(Color.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.bValue, in: 0.0...255.0)
                            .accentColor(Color.blue.opacity(session.bValue))
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
                    Toggle(isOn: $session.darkThemeOverride) {
                            Text("Принудительная темная тема")
                    }
                }
                Section(header: Text("Личные данные").bold(), footer: Text("Здесь вы можете отредактировать ваши личные данные, их могут видеть другие пользователи.")) {
                    TextField("Фамилия", text: $session.lastname)
                    TextField("Имя", text: $session.firstname)
                    TextField("Эл.почта", text: $session.email)
                    DatePicker(selection: $session.dateBirthDay, displayedComponents: [.date], label: {Text("Дата рождения")})
                    HStack {
                        Button("Изменить фотографию") {
                            self.showActionSheetImage = true
                        }.actionSheet(isPresented: $showActionSheetImage) {
                            ActionSheet(title: Text("Изменение фотографии"), message: Text("Скорость, с которой отобразиться новая фотография в профиле напрямую зависит от размера выбранной вами фотографии."), buttons: [
                                  .default(Text("Сделать фотографию")) {
                                    self.setModalView = 1
                                    self.isShowingModalView = true
                                    self.session.selectedSourceType = .camera
                                },.default(Text("Выбрать фотографию")) {
                                    self.setModalView = 1
                                    self.isShowingModalView = true
                                    self.session.selectedSourceType = .photoLibrary
                                },.destructive(Text("Удалить фотографию")) {
                                    self.session.urlImageProfile = self.deletedUrlImageProfile
                                },.cancel()
                            ])
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                        Image(systemName: "photo")
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                    }
                }
                Section(header: Text("Безопасность").bold(), footer: Text("Здесь вы можете изменить способы авторизации, установить параметры доступа к приложению.")) {
                    NavigationLink(destination: PinSetting(boolCodeAccess: $session.boolCodeAccess, pinCodeAccess: $session.pinCodeAccess, biometricAccess: $session.biometricAccess)) {
                        Text("Настройка входа")
                    }
                    NavigationLink(destination: SetAuth()) {
                        Text("Вариаты авторизации")
                    }
                }
                Section(header: Text("Факультет и группа").bold(), footer: Text("Укажите свой факультет и группу, эти параметры влияют на расписание занятий.")) {
                    Picker(selection: $session.choiseFaculty, label: Text("Выбранный факультет")) {
                        ForEach(0 ..< session.faculty.count) {
                            Text(self.session.faculty[$0])
                        }
                    }
                    Picker(selection: $session.choiseGroup, label: Text("Выбранная группа")) {
                        ForEach(0 ..< elements.count) {
                            Text(self.elements[$0].name)
                        }
                    }
                }
                Section(header: Text("Новости").bold(), footer: Text("Укажите более подходящую тему новостей для вас, которые будут отображаться в разделе \"Сегодня\" по умолчанию.")) {
                    Picker(selection: $session.choiseNews, label: Text("Выбранная тема")) {
                        ForEach(0 ..< session.news.count) {
                            Text(self.session.news[$0])
                        }
                    }
                }
                Section(header: Text("Информация").bold()) {
                    NavigationLink(destination: License()) {
                        Text("Лицензии")
                    }
                    NavigationLink(destination: Changelog()) {
                        Text("Список изменений")
                    }
                    NavigationLink(destination: Privacy()) {
                        Text("Политика конфиденциальности")
                    }
                    NavigationLink(destination: InfoApp()) {
                        Text("О приложении")
                    }
                }
                Section(header: Text("Другое").bold(), footer: Text("Если приложение занимает слишком много места, очистка кэша изображений поможет его освободить.")) {
                    HStack {
                        Button("Оценить") {
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/ru/app/altgtu/id1481944453")!)
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                        Image(systemName: "star")
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                    }
                    HStack {
                        Button("Поделиться") {
                            self.setModalView = 2
                            self.isShowingModalView = true
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                    }
                    HStack {
                        Button("Очистить кэш изображений") {
                            URLImageService.shared.cleanFileCache()
                            URLImageService.shared.resetFileCache()
                            self.showAlertCache = true
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                        Spacer()
                        Image(systemName: "trash")
                            .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                    }
                    HStack {
                        Button("Удалить аккаунт") {
                            self.showActionSheet = true
                        }.foregroundColor(.red)
                        Spacer()
                        Image(systemName: "flame")
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $isShowingModalView, onDismiss: {
                if self.setModalView == 1 {
                    self.session.uploadImageToCloudStorage()
                }
                if self.setModalView == 2 {
                    print("SHARE")
                }
            }, content: {
                if self.setModalView == 1 {
                    ImagePicker(imageFromPicker: self.$session.imageProfile, selectedSourceType: self.$session.selectedSourceType)
                        .edgesIgnoringSafeArea(.bottom)
                }
                if self.setModalView == 2 {
                    ShareSheet(sharing: ["Удобное расписание в приложение АлтГТУ! https://apps.apple.com/ru/app/altgtu/id1481944453"])
                        .edgesIgnoringSafeArea(.bottom)
                }
            })
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Вы уверены, что хотите удалить свой аккаунт?"), message: Text("Вы не сможете восстановить его после удаления!"), buttons: [.destructive(Text("Удалить аккаунт")) {
                        self.session.currentLoginUser?.delete { error in
                            if let error = error {
                                print("Error delete users: \(error)")
                            } else {
                                self.session.signOut()
                                print("Deleting...")
                            }
                        }
                    }, .cancel()
                ])
            }
            .alert(isPresented: $showAlertCache) {
                Alert(title: Text("Успешно!"), message: Text("Кэш фотографий успешно очищен."), dismissButton: .default(Text("Хорошо")))
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .inline)
            .navigationBarItems(trailing: Button (action: {
                    self.isPresented = false
            })
            {
                Text("Готово")
                    .bold()
                    .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
            })
        }
        .onAppear(perform: test)
        .accentColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Rectangle()
                        .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 130)
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
                Button (action:
                    {
                        self.session.setNotification()
                        self.session.readCard()
                    }, label: {
                        Text("Тест")
                            .bold()
                            .foregroundColor(.red)
                            .padding()
                })
            }
            .navigationBarItems(leading: Button (action: {
                        self.showActionSheetExit = true
                })
                {
                    Image(systemName: "square.and.arrow.down")
                        .imageScale(.large)
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.white)
            }, trailing: Button (action: {
                        self.isPresented = true
                })
                {
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
            .sheet(isPresented: $isPresented, onDismiss: {
                self.session.updateDataFromDatabase()
            }, content: {
                self.sliderModalPresentation
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
