//
//  RootView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject private var sessionStore: SessionStore = SessionStore.shared
    
    var body: some View {
        Group {
            if sessionStore.user != nil {
                LoadingLogic()
            } else {
                AuthenticationScreen()
            }
        }
    }
}
