//
//  ProfileFriends.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ProfileFriends: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        HStack {
            KFImage(URL(string: sessionStore.urlImageProfile))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .clipped()
                .frame(width: 120, height: 120)
            Spacer()
            VStack(alignment: .trailing) {
                Text("Лисин")
                    .fontWeight(.bold)
                    .font(.title)
                Text("Дмитрий")
                    .fontWeight(.bold)
                    .font(.title)
                Button(action: {}) {
                    HStack {
                        Text("В друзья")
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        Image(systemName: "person.crop.circle.badge.plus")
                            .imageScale(.large)
                            .foregroundColor(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(Color.rgb(red: sessionStore.rValue, green: sessionStore.gValue, blue: sessionStore.bValue))
                        .opacity(0.2))
                }
            }
        }
    }
}
