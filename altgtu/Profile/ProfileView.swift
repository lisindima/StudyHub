//
//  ContentView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import KingfisherSwiftUI

struct ProfileView: View {
    
    @State private var showSettingModal: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var showQRReader: Bool = false
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var pickerStore: PickerStore = PickerStore.shared
    
    let currentUser = Auth.auth().currentUser!
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if sessionStore.choiseTypeBackroundProfile == false {
                        Rectangle()
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 130)
                    } else {
                        KFImage(URL(string: sessionStore.setImageForBackroundProfile))
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
                        if sessionStore.adminSetting {
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
                        Text((sessionStore.lastname!) + " " + (sessionStore.firstname!))
                            .bold()
                            .font(.title)
                        Text(currentUser.email!)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }.padding()
                }
                Spacer()
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
            .actionSheet(isPresented: $showActionSheetExit) {
                ActionSheet(title: Text("Вы уверены, что хотите выйти из этого аккаунта?"), message: Text("Для продолжения использования приложения вам потребуется повторно войти в аккаунт!"), buttons: [.destructive(Text("Выйти")) {
                    self.sessionStore.signOut()
                    }, .cancel()
                ])
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
            .sheet(isPresented: $showSettingModal, onDismiss: {
                if self.sessionStore.session == nil {
                    print("Сессии нет, данные не сохраняются")
                } else {
                    self.sessionStore.updateDataFromDatabase()
                    self.sessionStore.settingUserInstabug()
                    self.pickerStore.updateDataFromDatabasePicker()
                }
            }, content: {
                SettingView()
                    .environmentObject(self.sessionStore)
            })
        }
        .accentColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
