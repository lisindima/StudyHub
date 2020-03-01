//
//  ChatTextField.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.02.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChatTextField: View {
    
    @Binding var messageText: String
    
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: { print("Прикрепить") }) {
                Image(systemName: "paperclip")
                    .imageScale(.large)
            }
            ZStack {
                Capsule(style: .continuous)
                    .frame(height: 40)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                TextField("Новое сообщение...", text: $messageText)
                    .padding(.horizontal)
            }
            if !messageText.isEmpty {
                Button(action: action) {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                }
            } else {
                Button(action: { print("Микрофон") }) {
                    Image(systemName: "mic")
                        .imageScale(.large)
                }
            }
        }
    }
}
