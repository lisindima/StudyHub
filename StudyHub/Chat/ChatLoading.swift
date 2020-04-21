//
//  ChatLoading.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChatLoading: View {
    var body: some View {
        NavigationView {
            ActivityIndicator(styleSpinner: .large)
                .navigationBarTitle("Сообщения")
        }
    }
}

struct ChatLoading_Previews: PreviewProvider {
    static var previews: some View {
        ChatLoading()
    }
}
