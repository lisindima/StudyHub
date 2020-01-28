//
//  AuthLogic.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct AuthLogic: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    func getUser() {
        sessionStore.listen()
    }
    
    var body: some View {
        Group {
            if sessionStore.session != nil {
                LoadingLogic()
            } else {
                AuthenticationScreen()
            }
        }.onAppear(perform: getUser)
    }
}
