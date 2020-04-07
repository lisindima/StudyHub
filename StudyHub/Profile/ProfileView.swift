//
//  ContentView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
#if !targetEnvironment(macCatalyst)
import PartialSheet
#endif
import KingfisherSwiftUI

struct ProfileView: View {
    
    @State private var showSettingModal: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var showQRReader: Bool = false
    @State private var showPartialSheet: Bool = false
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject var pickerStore: PickerStore = PickerStore.shared
    
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if !sessionStore.choiseTypeBackroundProfile {
                        Rectangle()
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 130)
                    } else {
                        KFImage(URL(string: sessionStore.setImageForBackroundProfile))
                            .placeholder {
                                Rectangle()
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .edgesIgnoringSafeArea(.top)
                                    .frame(height: 130)
                        }
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 130)
                        .aspectRatio(contentMode: .fit)
                    }
                    ProfileImage()
                        .offset(y: -120)
                        .padding(.bottom, -130)
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
            }.sheet(isPresented: $showQRReader) {
                QRReader()
                    .edgesIgnoringSafeArea(.bottom)
                    .environmentObject(self.sessionStore)
            }, trailing: Button(action: {
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
                #if targetEnvironment(macCatalyst)
                SettingView(showPartialSheet: self.$showPartialSheet)
                    .environmentObject(self.sessionStore)
                #else
                SettingView(showPartialSheet: self.$showPartialSheet)
                    .environmentObject(self.sessionStore)
                    .partialSheet(presented: self.$showPartialSheet, backgroundColor: Color(UIColor.secondarySystemBackground)) {
                        ChangeIcons()
                            .environmentObject(self.sessionStore)
                }
                #endif
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
