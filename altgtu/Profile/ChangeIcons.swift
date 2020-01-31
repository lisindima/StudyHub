//
//  ChangeIcons.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChangeIcons: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100)
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100)
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100)
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100)
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100)
            }.padding(.horizontal)
        }
    }
}

struct ChangeIcons_Previews: PreviewProvider {
    static var previews: some View {
        ChangeIcons()
    }
}
