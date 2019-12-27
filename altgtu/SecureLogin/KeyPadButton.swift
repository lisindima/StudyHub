//
//  KeyPadButton.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct KeyPadButton: View {
    
    @EnvironmentObject var session: SessionStore
    var key: String

    var body: some View {
        Button(action: { self.action(self.key) }) {
            Text(key)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0))
                .font(.system(size: 25))
                .frame(width: 70, height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color(red: session.rValue/255.0, green: session.gValue/255.0, blue: session.bValue/255.0, opacity: 1.0), lineWidth: 2)
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
