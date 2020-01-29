//
//  ChatEmpty.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChatEmpty: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    LottieView(filename: "14571-search-loading-animation")
                        .frame(width: 200, height: 200)
                    Text("Нет сообщений")
                        .font(.headline)
                    Text("Отправьте свое первое сообщение")
                        .font(.subheadline)
                }
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            print("Новое сообщение")
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Новое сообщение")
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                            }
                        }
                        Spacer()
                    }.padding()
                }
            }.navigationBarTitle(Text("Сообщения"))
        }
    }
}

struct ChatEmpty_Previews: PreviewProvider {
    static var previews: some View {
        ChatEmpty()
    }
}
