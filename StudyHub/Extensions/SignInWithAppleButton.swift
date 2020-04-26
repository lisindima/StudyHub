//
//  SignInWithAppleButton.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 21.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Firebase
import CryptoKit
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        var parent: SignInWithAppleView
        fileprivate var currentNonce: String?
        
        init(_ parent: SignInWithAppleView) {
            self.parent = parent
        }
        
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: Array<Character> =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length
            
            while remainingLength > 0 {
                let randoms: [UInt8] = (0 ..< 16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                    }
                    return random
                }
                randoms.forEach { random in
                    if length == 0 {
                        return
                    }
                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }
            return result
        }
        
        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()
            return hashString
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if error != nil {
                        print((error?.localizedDescription)!)
                        return
                    }
                }
            }
        }
        
        @objc func didTapButton() {
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.presentationContextProvider = self
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            let viewController = UIApplication.shared.windows.last?.rootViewController
            return (viewController?.view.window!)!
        }
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        switch colorScheme {
        case .light:
            let button = ASAuthorizationAppleIDButton(type: .default, style: .black)
            button.addTarget(context.coordinator, action:  #selector(Coordinator.didTapButton), for: .touchUpInside)
            return button
        case .dark:
            let button = ASAuthorizationAppleIDButton(type: .default, style: .white)
            button.addTarget(context.coordinator, action:  #selector(Coordinator.didTapButton), for: .touchUpInside)
            return button
        @unknown default:
            let button = ASAuthorizationAppleIDButton(type: .default, style: .black)
            button.addTarget(context.coordinator, action:  #selector(Coordinator.didTapButton), for: .touchUpInside)
            return button
        }
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
