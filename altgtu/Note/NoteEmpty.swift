//
//  NoteEmpty.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteEmpty: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    VStack {
                        Text("Нет заметок")
                            .font(.headline)
                        Text("Создайте свою первую заметку!")
                            .font(.subheadline)
                    }
                    Spacer()
                }
            }.navigationBarTitle(Text("Заметки"))
        }
    }
}

struct NoteEmpty_Previews: PreviewProvider {
    static var previews: some View {
        NoteEmpty()
    }
}
