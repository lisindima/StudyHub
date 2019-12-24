//
//  KeyPad.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct KeyPadRow: View {
    var keys: [String]

    var body: some View {
        HStack {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
            }
        }
    }
}

struct KeyPad: View {
    
    @Binding var userInputPin: String

    var body: some View {
        VStack {
            KeyPadRow(keys: ["1", "2", "3"])
                .disabled(userInputPin.count > 3)
                .padding(.bottom)
            KeyPadRow(keys: ["4", "5", "6"])
                .disabled(userInputPin.count > 3)
                .padding(.bottom)
            KeyPadRow(keys: ["7", "8", "9"])
                .disabled(userInputPin.count > 3)
            HStack {
                Button (action: {
                        
                })
                {
                    Image(systemName: "faceid")
                        .foregroundColor(.defaultColorApp)
                        .font(.system(size: 25))
                        .frame(width: 70, height: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.defaultColorApp, lineWidth: 2)
                        )
                }
                KeyPadRow(keys: ["0"])
                    .disabled(userInputPin.count > 3)
                Button (action: {
                    self.userInputPin.removeLast()
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(.defaultColorApp)
                        .font(.system(size: 25))
                        .frame(width: 70, height: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.defaultColorApp, lineWidth: 2)
                        )
                }.disabled(userInputPin.count == 0)
            }
        }.environment(\.keyPadButtonAction, self.keyPressed(_:))
    }

    private func keyPressed(_ key: String) {
        userInputPin += key
    }
}
