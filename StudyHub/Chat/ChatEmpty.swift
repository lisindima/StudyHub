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
                    Text("Нет сообщений")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Text("Отправьте свое первое сообщение")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                VStack {
                    Spacer()
                    HStack {
                        PlusButton(action: {
                            print("Новое сообщение")
                        }, label: "Новое сообщение")
                        Spacer()
                    }.padding(12)
                }
            }.navigationBarTitle("Сообщения")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ChatEmpty_Previews: PreviewProvider {
    static var previews: some View {
        ChatEmpty()
    }
}
