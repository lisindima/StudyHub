//
//  SetAuth.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct SetAuth: View {
    var body: some View {
        VStack {
            LineView(data: [8, 23, 54, 32, 12, 37, 7, 23, 43], title: "Тест")
                .padding()
            Spacer()
                .layoutPriority(10)
        }.navigationBarTitle(Text("Варианты авторизации"), displayMode: .inline)
    }
}

struct SetAuth_Previews: PreviewProvider {
    static var previews: some View {
        SetAuth()
    }
}
