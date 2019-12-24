//
//  KeyPadButton.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct KeyPadButton: View {
    var key: String

    var body: some View {
        Button(action: { self.action(self.key) }) {
            Text(key)
                .fontWeight(.semibold)
                .foregroundColor(.defaultColorApp)
                .font(.system(size: 25))
                .frame(width: 70, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.defaultColorApp, lineWidth: 2)
                )
        }
    }

    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }

    @Environment(\.keyPadButtonAction) var action: (String) -> Void
}

extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get { self[KeyPadButton.ActionKey.self] }
        set { self[KeyPadButton.ActionKey.self] = newValue }
    }
}
