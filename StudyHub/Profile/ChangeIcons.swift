//
//  ChangeIcons.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine

class IconStore: ObservableObject {
    
    @Published var currentIconName: String = "defaultlogo"
    @Published var iconModel: [IconModel] = [
        IconModel(nameIcon: "defaultlogo", nameAuthorIcon: "По умолчанию"),
        IconModel(nameIcon: "altstulogo", nameAuthorIcon: "Герб \"АлтГТУ\""),
        IconModel(nameIcon: "lisinlogo", nameAuthorIcon: "Лисин Дмитрий"),
        IconModel(nameIcon: "pornlogo", nameAuthorIcon: "Хи-Хи😈")
    ]
    
    static let shared = IconStore()
    
    func getIcon() {
        if UIApplication.shared.alternateIconName == nil {
            currentIconName = "defaultlogo"
        } else if UIApplication.shared.alternateIconName == "altIconApp" {
            currentIconName = "lisin"
        } else if UIApplication.shared.alternateIconName == "pornlogo" {
            currentIconName = "pornlogo"
        }
    }
    
    func setIcon(nameIcon: String) {
        UIApplication.shared.setAlternateIconName(nameIcon == "defaultlogo" ? nil : nameIcon) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.currentIconName = nameIcon
            }
        }
    }
}

struct ChangeIcons: View {
    
    @ObservedObject var iconStore: IconStore = IconStore.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(iconStore.iconModel, id: \.id) { icon in
                    IconItem(iconModel: icon)
                }
            }.padding(.horizontal)
        }.onAppear(perform: iconStore.getIcon)
    }
}

struct IconItem: View {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    @ObservedObject var iconStore: IconStore = IconStore.shared
    
    var iconModel: IconModel
    
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                self.iconStore.setIcon(nameIcon: self.iconModel.nameIcon)
            }) {
                Image(iconModel.nameIcon)
                    .resizable()
                    .renderingMode(.original)
                    .cornerRadius(15)
                    .frame(width: 80, height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue), lineWidth: 3)
                            .opacity(iconStore.currentIconName == iconModel.nameIcon ? 1.0 : 0.0)
                            .frame(width: 90, height: 90)
                )
            }.frame(width: 95, height: 95)
            Text(iconModel.nameAuthorIcon)
                .font(.system(size: 11, design: .rounded))
                .fontWeight(.bold)
        }
    }
}

struct IconModel: Identifiable {
    let id: UUID = UUID()
    let nameIcon: String
    let nameAuthorIcon: String
}
