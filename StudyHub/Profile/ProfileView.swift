//
//  ContentView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import PartialSheet
import KingfisherSwiftUI

struct ProfileView: View {
    
    @State private var showSettingModal: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var showQRReader: Bool = false
    @State private var showActionSheetImage: Bool = false
    @State private var isShowingModalViewImage: Bool = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject private var pickerStore: PickerStore = PickerStore.shared
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    let currentUser = Auth.auth().currentUser
    
    private let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if !sessionStore.userData.choiseTypeBackroundProfile {
                        Rectangle()
                            .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                            .edgesIgnoringSafeArea(.top)
                            .frame(height: 130)
                    } else {
                        KFImage(URL(string: sessionStore.userData.setImageForBackroundProfile))
                            .placeholder {
                                Rectangle()
                                    .foregroundColor(Color.systemBackground)
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
                        Text(sessionStore.userData.lastname + " " + sessionStore.userData.firstname)
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
                    .environmentObject(self.partialSheetManager)
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
                }
            }, content: {
                SettingView()
                    .environmentObject(self.partialSheetManager)
                    .environmentObject(self.sessionStore)
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
