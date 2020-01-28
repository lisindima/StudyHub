//
//  LoadingScreen.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LoadingLogic: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    @State private var access: Bool = false
    
    func getData() {
        sessionStore.getDataFromDatabaseListen()
    }
    
    var body: some View {
        ZStack {
            if sessionStore.lastname != nil && sessionStore.boolCodeAccess == false {
                Tabbed()
            } else if sessionStore.lastname != nil && sessionStore.boolCodeAccess == true && access == true {
                Tabbed()
            } else if sessionStore.lastname != nil && sessionStore.boolCodeAccess == true && access == false {
                SecureView(access: $access)
            } else {
                ActivityIndicator(styleSpinner: .large)
            }
        }.onAppear(perform: getData)
    }
}
