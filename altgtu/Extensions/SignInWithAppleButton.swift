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
        SignInWithAppleView(style: colorScheme == .dark ? .white : .black)
    }
}

struct SignInWithAppleView: UIViewRepresentable {
    
    var style : ASAuthorizationAppleIDButton.Style = .white
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .default, style: style)
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
