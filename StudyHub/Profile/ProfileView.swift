//
//  ContentView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Firebase
import KingfisherSwiftUI
import SwiftUI

struct ProfileView: View {
    @State private var showSettingModal: Bool = false
    @State private var showActionSheetExit: Bool = false
    @State private var showQRReader: Bool = false

    @EnvironmentObject var sessionStore: SessionStore

    let currentUser = Auth.auth().currentUser

    private let deletedUrlImageProfile: String = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2FPortrait_Placeholder.jpeg?alt=media&token=1af11651-369e-4ff1-a332-e2581bd8e16d"

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Rectangle()
                        .foregroundColor(Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue))
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 130)
                    ProfileImage()
                        .offset(y: -115)
                        .padding(.bottom, -130)
                    VStack {
                        Text(sessionStore.userData.lastname + " " + sessionStore.userData.firstname)
                            .fontWeight(.bold)
                            .font(.title)
                        Text(currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }.padding()
                }
                Spacer()
                Button(action: {
                    showActionSheetExit = true
                }, label: {
                    Text("Выйти")
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                        .foregroundColor(.red)
                }).padding()
            }
            .actionSheet(isPresented: $showActionSheetExit) {
                ActionSheet(title: Text("Вы уверены, что хотите выйти из этого аккаунта?"), message: Text("Для продолжения использования приложения вам потребуется повторно войти в аккаунт!"), buttons: [.destructive(Text("Выйти")) {
                    sessionStore.signOut()
                }, .cancel()])
            }
            .navigationBarItems(leading: Button(action: {
                showQRReader = true
            }) {
                Image(systemName: "qrcode")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }.sheet(isPresented: $showQRReader) {
                QRReader()
                    .edgesIgnoringSafeArea(.bottom)
                    .environmentObject(sessionStore)
            }, trailing: Button(action: {
                showSettingModal = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(.white)
            })
            .sheet(isPresented: $showSettingModal, onDismiss: {
                if sessionStore.user != nil {
                    sessionStore.updateDataFromDatabase()
                }
            }, content: {
                SettingView()
                    .environmentObject(sessionStore)
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
