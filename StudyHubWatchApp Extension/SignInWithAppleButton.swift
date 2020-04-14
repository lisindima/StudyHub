//
//  SignInWithAppleButton.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 14.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: WKInterfaceObjectRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate {
        
        @objc func didTapButton() {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<SignInWithAppleButton>) -> WKInterfaceAuthorizationAppleIDButton {
        let button = WKInterfaceAuthorizationAppleIDButton(style: .default, target: context.coordinator, action: #selector(Coordinator.didTapButton))
        return button
    }
    
    func updateWKInterfaceObject(_ map: WKInterfaceAuthorizationAppleIDButton, context: WKInterfaceObjectRepresentableContext<SignInWithAppleButton>) {
        
    }
}

struct SignInWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButton()
    }
}
