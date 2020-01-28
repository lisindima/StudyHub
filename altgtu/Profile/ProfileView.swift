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
    @EnvironmentObject var session: SessionStore
    
    let currentUser = Auth.auth().currentUser!
    
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
                    self.session.signOut()
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
                self.session.session == nil ? print("Сессии нет, данные не сохраняются") : self.session.updateDataFromDatabase()
                self.session.setInstabugColor()
            }, content: {
                SettingView()
                    .environmentObject(self.session)
            })
        }
        .accentColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
