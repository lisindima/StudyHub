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
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        VStack {
            KFImage(URL(string: sessionStore.urlImageProfile))
                .placeholder {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 210, height: 210)
                        ActivityIndicator(styleSpinner: .large)
                    }
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .frame(width: 210, height: 210)
        }
    }
}