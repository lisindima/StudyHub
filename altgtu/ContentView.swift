//
//  ContentView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView : View {
    
    @EnvironmentObject var session: SessionStore

    func getUser() {
        session.listen()
        session.LocalAuthFunc()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                if (session.LocalAuthVerification == true) {
                    Tabbed()
                }
                else {
                    AuthenticationScreen()
                }
            } else {
                AuthenticationScreen()
            }
        }.onAppear(perform: getUser)
    }
}
/*
struct LocalAuth : View {
    
    @EnvironmentObject var session: SessionStore
    
    func getAuth() {
        session.LocalAuthFunc()
    }
    
    var body: some View {
        Group {
            if (session.LocalAuthVerification == true) {
                Tabbed()
            } else {
                AuthenticationScreen()
            }
        }.onAppear(perform: getAuth)
    }
}
*/
