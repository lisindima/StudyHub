//
//  LinkedAccounts.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LinkedAccounts: View {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    
    var body: some View {
        Form {
            Section(header: Text("Аккаунты для входа").fontWeight(.bold), footer: Text("Активируя эти аккаунты, вы сможете входить в ваш профиль используя любой из них.")) {
                NavigationLink(destination: Changelog()) {
                    HStack {
                        Text("")
                            .font(.title)
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
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
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Вход через почту и пароль")
                        Spacer()
                        Text("Вкл")
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section {
                if sessionStore.userTypeAuth == .email {
                    NavigationLink(destination: ChangeEmail()) {
                        Image(systemName: "envelope")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Изменить эл.почту")
                    }
                    NavigationLink(destination: ChangePassword()) {
                        Image(systemName: "lock")
                            .frame(width: 24)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Text("Изменить пароль")
                    }
                }
            }
            Section {
                NavigationLink(destination: DeleteUser()) {
                    Image(systemName: "flame")
                        .frame(width: 24)
                        .foregroundColor(.red)
                    Text("Удалить аккаунт")
                        .foregroundColor(.red)
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Управление аккаунтами"), displayMode: .inline)
    }
}

struct SetAuth_Previews: PreviewProvider {
    static var previews: some View {
        LinkedAccounts()
    }
}
