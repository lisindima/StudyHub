//
//  Changelog.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Changelog: View {
    var body: some View {
        VStack {
            Text("Список изменений")
        }.navigationBarTitle(Text("Список изменений"), displayMode: .inline)
    }
}

struct Changelog_Previews: PreviewProvider {
    static var previews: some View {
        Changelog()
    }
}
