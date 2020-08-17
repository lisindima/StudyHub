//
//  ProfileImage.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct ProfileImage: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var showAdminCheck: Bool = false

    var body: some View {
        ZStack {
            KFImage(URL(string: sessionStore.userData.urlImageProfile), isLoaded: $showAdminCheck)
                .placeholder { ProgressView() }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .frame(width: 210, height: 210)
            if sessionStore.userData.adminSetting && showAdminCheck {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.systemBackground)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }.offset(x: 80, y: 80)
            }
        }
    }
}
