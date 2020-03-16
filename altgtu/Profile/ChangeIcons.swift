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
    
    @Published var currentIconName: String = "infoApp"
    @Published var iconModel: Array = [
        IconModel(nameIcon: "infoApp", nameAuthorIcon: "Герб \"АлтГТУ\""),
        IconModel(nameIcon: "altIconApp", nameAuthorIcon: "Лисин Дмитрий")
    ]
    
    static let shared = IconStore()
    
    func getIcon() {
        if UIApplication.shared.alternateIconName == nil {
            currentIconName = "infoApp"
        } else if UIApplication.shared.alternateIconName == "altIconApp" {
            currentIconName = "altIconApp"
        }
    }
    
    func setIcon(nameIcon: String) {
        UIApplication.shared.setAlternateIconName(nameIcon == "infoApp" ? nil : nameIcon) { error in
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
    
    @EnvironmentObject var sessionStore: SessionStore
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
                            .stroke(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: iconStore.currentIconName == iconModel.nameIcon ? 1.0 : 0.0), lineWidth: 3)
                            .frame(width: 90, height: 90)
                )
            }.frame(width: 95, height: 95)
            Text(iconModel.nameAuthorIcon)
                .font(.system(size: 11, design: .rounded))
                .bold()
        }
    }
}

struct IconModel: Identifiable {
    let id: UUID = UUID()
    let nameIcon: String
    let nameAuthorIcon: String
}
