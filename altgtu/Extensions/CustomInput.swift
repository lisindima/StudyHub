//
//  CustomInput.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct InputModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1)
                .foregroundColor(Color.secondary.opacity(0.4)))
    }
}

struct CustomInput: View {
    @Binding var text: String
    var name: String
    
    var body: some View {
        TextField(name, text: $text)
            .modifier(InputModifier())
    }
}

struct CustomInput_Previews: PreviewProvider {
    static var previews: some View {
        CustomInput(text: .constant(""), name: "Some name")
            .padding()
    }
}
