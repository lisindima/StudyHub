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
    
    var body: some View {
        Group {
            if sessionStore.userData != nil {
                Tabbed()
            } else {
                ActivityIndicator(styleSpinner: .large)
            }
        }
    }
}
