//
//  ChatTextField.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChatTextField: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let sendAction: (String) -> Void
    
    @Binding var messageText: String
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .shadow(radius: 3, x: 0, y: -2)
            HStack {
                TextField("Введите сообщение", text: $messageText)
                    .frame(height: 60)
                Button(action: sendButtonTapped) {
                    Image("send_message")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 16)
                }
            }
            .padding([.leading, .trailing])
            .background(colorScheme == .dark ? Color.black : Color.white)
        }.frame(height: 60)
    }
    
    private func sendButtonTapped() {
        sendAction(messageText)
        messageText = ""
    }
}
