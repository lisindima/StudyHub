//
//  RootView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        Group {
            if sessionStore.user != nil && sessionStore.userData != nil {
                TabViewUIkit()
            } else if sessionStore.user != nil && sessionStore.userData == nil {
                ActivityIndicator(styleSpinner: .large)
            } else {
                AuthenticationScreen()
            }
        }
    }
}
