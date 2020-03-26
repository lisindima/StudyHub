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
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if sessionStore.choiseTypeBackroundProfile == false {
                        Rectangle()
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
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
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                
                            }.offset(x: 80, y: 25)
                        }
                    }
                    VStack {
                        Text((sessionStore.lastname!) + " " + (sessionStore.firstname!))
                            .fontWeight(.bold)
                            .font(.title)
                        Text(currentUser!.email!)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }.padding()
                }
                Spacer()
                Button(action: {
                    self.showActionSheetExit = true
                }, label: {
                    Text("Выйти")
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                        .foregroundColor(.red)
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
                    .edgesIgnoringSafeArea(.bottom)
                    .environmentObject(self.sessionStore)
            }), trailing: Button(action: {
                self.showSettingModal = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(.white)
            })
            .sheet(isPresented: $showSettingModal, onDismiss: {
                if self.sessionStore.user != nil {
                    self.sessionStore.updateDataFromDatabase()
                    self.pickerStore.updateDataFromDatabasePicker()
                }
            }, content: {
                SettingView()
                    .environmentObject(self.sessionStore)
            })
        }
        .accentColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
