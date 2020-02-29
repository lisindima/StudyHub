//
//  PermissionSplashScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 27.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct PermissionSplashScreen: View {
    
    @Binding var dismissSheet: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                TitlePermissionView()
                    .padding(.bottom)
                    .padding(.top, 50)
                    .accentColor(.defaultColorApp)
                PermissionContainerView()
                    .padding(.bottom, 50)
                    .accentColor(.defaultColorApp)
            }
            Spacer()
            HStack {
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    self.dismissSheet = false
                }) {
                    Text("Продолжить")
                        .customButton()
                }
            }
            .padding(.top, 8)
            .padding(.horizontal)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct PermissionContainerView: View {
    
    @ObservedObject var notificationStore: NotificationStore = NotificationStore.shared
    
    @State private var permissionPhoto: Bool = false
    @State private var permissionCamera: Bool = false
    @State private var permissionNotification: Bool = false
    @State private var permissionFaceID: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            PermissionInformationToggle(permissionActivate: $permissionPhoto, title: "Галерея", subTitle: "Просмотр расписания всех факультетов и групп университета.", imageName: "photo")
            PermissionInformationToggle(permissionActivate: $permissionCamera, title: "Камера", subTitle: "Начните общаться со своими одногруппниками используя удобный чат со сквозным шифрованием.", imageName: "camera")
            PermissionInformationToggle(permissionActivate: $permissionNotification, title: "Уведомления", subTitle: "Узнавайте все новости из мира и жизни университета.", imageName: "app.badge")
            PermissionInformationToggle(permissionActivate: $permissionFaceID, title: "Face ID", subTitle: "Узнавайте все новости из мира и жизни университета.", imageName: "faceid")
        }
        .padding(.horizontal)
    }
}

struct PermissionInformationToggle: View {
    
    @ObservedObject var notificationStore: NotificationStore = NotificationStore.shared
    @Binding var permissionActivate: Bool
    
    var title: String
    var subTitle: String
    var imageName: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .frame(width: 30)
                .foregroundColor(.accentColor)
                .padding()
                .accessibility(hidden: true)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            HStack {
                if !permissionActivate && notificationStore.enabled == .notDetermined {
                    Toggle(isOn: $permissionActivate) {
                        Text("")
                    }
                    .labelsHidden()
                    .frame(width: 50)
                } else if permissionActivate && notificationStore.enabled == .notDetermined {
                    ActivityIndicator(styleSpinner: .medium)
                        .frame(width: 50)
                } else if notificationStore.enabled == .authorized {
                    Image(systemName: "checkmark.circle.fill")
                        .frame(width: 50)
                        .foregroundColor(.accentColor)
                        .imageScale(.large)
                }
            }
        }
    }
}

struct TitlePermissionView: View {
    var body: some View {
        VStack {
            Image(systemName: "questionmark.square.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentColor)
            Text("Запрос на")
                .customTitleText()
            Text("разрешения")
                .customTitleText()
        }
    }
}