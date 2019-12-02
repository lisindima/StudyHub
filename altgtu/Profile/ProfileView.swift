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
import SwiftUICharts

struct ProfileView: View {
    
@State private var showActionSheet: Bool = false
@State private var showAlertCache: Bool = false
@State private var isPresented: Bool = false
@State private var isShowingModalView: Bool = false
@State private var InfoPageModal: Bool = false
@State private var showActionSheetExit: Bool = false
@State private var ModalView = 1
@State private var AlertView = 1
    
@Environment(\.colorScheme) var colorScheme: ColorScheme
@EnvironmentObject var session: SessionStore
@ObservedObject var pickerModel: pickerAPI = pickerAPI()
    
let currentUser = Auth.auth().currentUser!
    
    var StatisticsUser: some View {
        NavigationView {
            VStack {
                HStack {
                    LineView(data: [8,23,54,32,12,37,7,23,43], title: "Успеваемость", legend: "По дням")
                }.padding()
                Spacer()
            }
            .navigationBarTitle(Text("Статистика"), displayMode: .inline)
            .navigationBarItems(trailing: Button (action: {
                self.isPresented = false
            })
            {
                Text("Готово")
                    .bold()
                    .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    var SliderModalPresentation: some View {
        NavigationView {
            Form {
                Section(header: Text("Главное").bold(), footer: Text("Здесь настраивается время отсрочки уведомлений, например, для уведомлений о начале пары.")) {
                    Toggle(isOn: $session.NotifyAlertProfile.animation()) {
                            Text("Уведомления")
                    }
                    if session.NotifyAlertProfile {
                        Stepper("\(session.NotifyMinute) мин", value: $session.NotifyMinute, in: 5...30)
                    }
                }
                Section(header: Text("Оформление").bold(), footer: Text("Здесь настраивается цвет акцентов в приложение.")) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.red.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.rValue, in: 0.0...1.0)
                            .accentColor(Color.red.opacity(session.rValue))
                        Image(systemName: "r.circle.fill")
                            .foregroundColor(Color.red)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "g.circle")
                            .foregroundColor(Color.green.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.gValue, in: 0.0...1.0)
                            .accentColor(Color.green.opacity(session.gValue))
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(Color.green)
                            .font(.system(size: 25))
                    }.padding(.vertical)
                    HStack {
                        Image(systemName: "b.circle")
                            .foregroundColor(Color.blue.opacity(0.5))
                            .font(.system(size: 20))
                        Slider(value: $session.bValue, in: 0.0...1.0)
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
                            .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
                        HStack {
                            Text("R: \(Int(session.rValue * 255.0))")
                            Text("G: \(Int(session.gValue * 255.0))")
                            Text("B: \(Int(session.bValue * 255.0))")
                        }
                        .font(Font.custom("Futura", size: 24))
                        .foregroundColor(.white)
                    }
                    .padding(.vertical)
                }
                Section(header: Text("Личные данные").bold(), footer: Text("Здесь вы можете отредактировать ваши личные данные, их могут видеть другие пользователи.")) {
                    TextField("\(session.lastnameProfile)", text: $session.lastnameProfile)
                    TextField("\(session.firstnameProfile)", text: $session.firstnameProfile)
                    DatePicker(selection: $session.DateBirthDay, displayedComponents: [.date], label: {Text("Дата рождения")})
                    TextField("\(session.emailProfile)", text: $session.emailProfile)
                    HStack {
                        Button("Изменить фотографию") {
                            self.ModalView = 1
                            self.isShowingModalView = true
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                        
                            Spacer()
                        Image(systemName: "photo")
                            .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
                    }
                }
                Section(header: Text("Факультет и группа").bold(), footer: Text("Укажите свой факультет и группу, эти параметры влияют на расписание занятий.")) {
                    Picker(selection: $session.choiseFaculty, label: Text("Выбранный факультет")) {
                        ForEach(0 ..< session.Faculty.count) {
                            Text(self.session.Faculty[$0])
                        }
                    }
                    Picker(selection: $session.choiseGroup, label: Text("Выбранная группа")) {
                        ForEach(0 ..< session.Group.count) {
                            Text(self.session.Group[$0])
                        }
                    }
                }
                Section(header: Text("Новости").bold(), footer: Text("Укажите более подходящую тему новостей для вас, которые будут отображаться в разделе \"Сегодня\" по умолчанию.")) {
                    Picker(selection: $session.choiseNews, label: Text("Выбранная тема")) {
                        ForEach(0 ..< session.News.count) {
                            Text(self.session.News[$0])
                        }
                    }
                }
                Section(header: Text("Информация").bold()) {
                    HStack {
                        Button("Поделиться") {
                            self.ModalView = 2
                            self.isShowingModalView = true
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                            Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
                    }
                    HStack {
                        Button("Оценить") {
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/ru/app/altgtu/id1481944453")!)
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                            Spacer()
                        Image(systemName: "star")
                            .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
                    }
                    NavigationLink(destination: License()) {
                        Text("Лицензии")
                    }
                    NavigationLink(destination: InfoApp()) {
                        Text("О приложении")
                    }
                }
                Section(header: Text("Другое").bold(), footer: Text("Если приложение занимает слишком много места, очистка кэша изображений поможет его освободить.")) {
                    HStack {
                        Button("Очистить кэш изображений") {
                            URLImageService.shared.cleanFileCache()
                            URLImageService.shared.resetFileCache()
                            self.showAlertCache = true
                        }.foregroundColor(colorScheme == .light ? .black : .white)
                            Spacer()
                        Image(systemName: "trash")
                            .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
                    }
                    Button("Удалить аккаунт") {
                        self.showActionSheet = true
                        }
                        .foregroundColor(.red)
                    }
                
                }
                .sheet(isPresented: $isShowingModalView, onDismiss: {
                    if self.ModalView == 1 {
                        self.session.uploadImageToCloudStorage()
                    }
                    if self.ModalView == 2 {
                        print("SHARE")
                    }
                }, content: {
                    if self.ModalView == 1 {
                        ImagePicker(imageFromPicker: self.$session.imageProfile)
                    }
                    if self.ModalView == 2 {
                        ShareSheet(sharing: ["Удобное расписание в приложение АлтГТУ! https://apps.apple.com/ru/app/altgtu/id1481944453"])
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
                        .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
            })
        }
        .accentColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Header()
                        .foregroundColor(Color(red: session.rValue, green: session.gValue, blue: session.bValue, opacity: 1.0))
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 130)
                    ProfileImage()
                        .offset(y: -120)
                        .padding(.bottom, -130)
                    VStack {
                        HStack {
                            Text((session.lastnameProfile ?? "Загрузка...") + " " + (session.firstnameProfile ?? ""))
                                .bold()
                                .font(.title)
                            if session.adminSetting {
                                Image(systemName: "checkmark.seal.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.blue)
                            }
                        }
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
                ActionSheet(title: Text("Вы уверены, хотите выйти из этого аккаунта?"), message: Text("Для продолжения использования приложения вам потребуется повторно войти в аккаунт!"), buttons: [.destructive(Text("Выйти")) {
                        self.session.signOut()
                    }, .cancel()
                ])
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                self.session.updateDataFromDatabase()
            }, content: {
                self.SliderModalPresentation
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
