//
//  ProfileImage.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct ProfileImage: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            KFImage(URL(string: session.urlImageProfile))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .shadow(radius: 10)
                .frame(width: 210, height: 210)
        }
    }
}
