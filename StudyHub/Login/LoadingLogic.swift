//
//  LoadingLogic.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 10.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LoadingLogic: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    
    @State private var access: Bool = false
    
    var body: some View {
        Group {
            if sessionStore.userData != nil && !sessionStore.userData.boolCodeAccess {
                Tabbed()
            } else if sessionStore.userData != nil && sessionStore.userData.boolCodeAccess && access {
                Tabbed()
            } else if sessionStore.userData != nil && sessionStore.userData.boolCodeAccess && !access {
                SecureView(access: $access)
            } else {
                ActivityIndicator(styleSpinner: .large)
            }
        }
    }
}
