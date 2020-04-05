//
//  LoadingLogic.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 10.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LoadingLogic: View {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    
    @State private var access: Bool = false
    
    var body: some View {
        Group {
            if sessionStore.lastname != nil && !sessionStore.boolCodeAccess {
                Tabbed()
            } else if sessionStore.lastname != nil && sessionStore.boolCodeAccess && access {
                Tabbed()
            } else if sessionStore.lastname != nil && sessionStore.boolCodeAccess && !access {
                SecureView(access: $access)
            } else {
                ActivityIndicator(styleSpinner: .large)
            }
        }
    }
}
