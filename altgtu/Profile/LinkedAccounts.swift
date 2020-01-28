//
//  LinkedAccounts.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LinkedAccounts: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        Form {
            Section(header: Text("Аккаунты для входа").bold(), footer: Text("Активируя эти аккаунты, вы сможете входить в ваш профиль используя любой из них.")) {
                NavigationLink(destination: Changelog()) {
                    HStack {
                        Text("")
                            .font(.title)
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Вход через Apple")
                        Spacer()
                        Text("Выкл")
                            .foregroundColor(.secondary)
                    }
                }
                NavigationLink(destination: Changelog()) {
                    HStack {
                        Image(systemName: "envelope")
                            .frame(width: 24)
                            .foregroundColor(Color(red: sessionStore.rValue/255.0, green: sessionStore.gValue/255.0, blue: sessionStore.bValue/255.0, opacity: 1.0))
                        Text("Вход через почту и пароль")
                        Spacer()
                        Text("Вкл")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Связанные аккаунты"), displayMode: .inline)
    }
}

struct SetAuth_Previews: PreviewProvider {
    static var previews: some View {
        LinkedAccounts()
    }
}
