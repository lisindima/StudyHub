//
//  SignInWithAppleButton.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 21.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Group {
            if colorScheme == .light {
                SignInWithAppleView(colorScheme: .light)
            } else {
                SignInWithAppleView(colorScheme: .dark)
            }
        }
    }
}

struct SignInWithAppleView: UIViewRepresentable {
    
    var colorScheme: ColorScheme
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        switch colorScheme {
        case .light:
            return ASAuthorizationAppleIDButton(type: .default, style: .black)
        case .dark:
            return ASAuthorizationAppleIDButton(type: .default, style: .white)
        @unknown default:
            return ASAuthorizationAppleIDButton(type: .default, style: .black)
        }
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
