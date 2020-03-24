//
//  NoteLoading.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteLoading: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    ActivityIndicator(styleSpinner: .large)
                    Spacer()
                }
            }.navigationBarTitle(Text("Заметки"))
        }
    }
}

struct NoteLoading_Previews: PreviewProvider {
    static var previews: some View {
        NoteLoading()
    }
}
