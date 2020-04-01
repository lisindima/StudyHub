//
//  ProfileImage.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ProfileImage: View {
    
    @ObservedObject var sessionStore: SessionStore = SessionStore.shared
    
    var body: some View {
        ZStack {
            KFImage(URL(string: sessionStore.urlImageProfile))
                .placeholder { ActivityIndicator(styleSpinner: .large) }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .frame(width: 210, height: 210)
            if sessionStore.adminSetting {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(UIColor.systemBackground))
                    Image(systemName: "checkmark.seal.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }.offset(x: 80, y: 80)
            }
        }.shadow(radius: 10)
    }
}
