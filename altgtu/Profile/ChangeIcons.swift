//
//  ChangeIcons.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

class IconStore: ObservableObject {
    
    @Published var nameIcon: ActiveIconName = .primary
    static let shared = IconStore()
    
    func getNameIcon() {
        if UIApplication.shared.alternateIconName == nil {
            nameIcon = .primary
        } else if UIApplication.shared.alternateIconName == "IconCodeName" {
            nameIcon = .alternate
        }
    }
    
    func setAlternateIcon() {
        UIApplication.shared.setAlternateIconName("IconCodeName") { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Кастомная иконка установлена!")
                self.nameIcon = .alternate
            }
        }
    }
    
    func setPrimaryIcon() {
        UIApplication.shared.setAlternateIconName(nil) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Стандартная иконка установлена!")
                self.nameIcon = .primary
            }
        }
    }
}

struct ChangeIcons: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var iconStore: IconStore = IconStore.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                VStack(alignment: .center) {
                    Button(action: iconStore.setPrimaryIcon) {
                        Image("infoApp")
                            .resizable()
                            .renderingMode(.original)
                            .cornerRadius(15)
                            .frame(width: 80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: iconStore.nameIcon == .primary ? 1.0 : 0.0), lineWidth: 3)
                                    .frame(width: 90, height: 90)
                        )
                    }.frame(width: 95, height: 95)
                    Text("Стандартная")
                        .font(.system(size: 11, design: .rounded))
                        .bold()
                }
                VStack(alignment: .center) {
                    Button(action: iconStore.setAlternateIcon) {
                        Image("altIconApp")
                            .resizable()
                            .renderingMode(.original)
                            .cornerRadius(15)
                            .frame(width: 80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: iconStore.nameIcon == .primary ? 0.0 : 1.0), lineWidth: 3)
                                    .frame(width: 90, height: 90)
                        )
                    }.frame(width: 95, height: 95)
                    Text("Автор иконки")
                        .font(.system(size: 11, design: .rounded))
                        .bold()
                }
            }.padding(.horizontal)
        }.onAppear(perform: iconStore.getNameIcon)
    }
}

enum ActiveIconName {
    case primary
    case alternate
}

struct ChangeIcons_Previews: PreviewProvider {
    static var previews: some View {
        ChangeIcons()
    }
}
