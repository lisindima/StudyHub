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
            KeyPadRow(keys: ["4", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            KeyPadRow(keys: [".", "0", "⌫"])
        }.environment(\.keyPadButtonAction, self.keyPressed(_:))
    }

    private func keyPressed(_ key: String) {
        switch key {
        case "." where userInputPin.contains("."): break
        case "." where userInputPin == "0": userInputPin += key
        case "⌫":
            userInputPin.removeLast()
            if userInputPin.isEmpty { userInputPin = "0" }
        case _ where userInputPin == "0": userInputPin = key
        default: userInputPin += key
        }
    }
}
