//
//  CustomButton.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct CustomButton : View {
    
    var label: String
    var action: () -> Void
    var loading: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                //ActivityIndicatorButton()
                //    .opacity(loading == true ? 1 : 0)
                Spacer()
            }
        }
        .padding()
        .background(Color.defaultColorApp)
        .cornerRadius(8)
    }
}

struct ActivityIndicatorButton: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorButton>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.color = .white
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorButton>) {
        
    }
}
