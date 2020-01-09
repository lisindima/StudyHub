//
//  ProfileImage.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage

struct ProfileImage: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            URLImage(URL(string:"\(session.urlImageProfile!)")!, incremental: false, expireAfter: Date(timeIntervalSinceNow: 31_556_926.0), placeholder: {
                ProgressView($0) { progress in
                    ZStack {
                        if progress > 0.0 {
                            CircleProgressView(progress).stroke(lineWidth: 8.0)
                                .frame(width: 50, height: 50)
                        }
                        else {
                            CircleActivityView().stroke(lineWidth: 50.0)
                                .frame(width: 50, height: 50)
                        }
                    }
                }.frame(width: 210, height: 210)
            }) { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .clipped()
                        .shadow(radius: 10)
                        .frame(width: 210, height: 210)
            }
        }
    }
}
