//
//  PlusButton.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 25.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct PlusButton: View {
    
    var action: () -> Void
    var label: String
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(label)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
            }
        }
        .padding(4)
        .hoverEffect(.lift)
    }
}
