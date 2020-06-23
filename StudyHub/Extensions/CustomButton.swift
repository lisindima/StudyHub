//
//  CustomButton.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct CustomButton: View {
    
    var label: String
    var loading: Bool
    var colorButton: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                if loading {
                    ProgressView()
                }
                Spacer()
            }
        }
        .padding()
        .background(colorButton)
        .cornerRadius(8)
        .hoverEffect(.highlight)
    }
}
