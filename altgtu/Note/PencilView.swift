//
//  PencilView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct PencilView: View {
    var body: some View {
        PencilKitCanvas()
            .edgesIgnoringSafeArea(.all)
    }
}

struct PencilView_Previews: PreviewProvider {
    static var previews: some View {
        PencilView()
    }
}
