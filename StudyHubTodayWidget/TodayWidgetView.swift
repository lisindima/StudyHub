//
//  TodayWidgetView.swift
//  StudyHubTodayWidget
//
//  Created by Дмитрий Лисин on 15.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct TodayWidgetView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 10)
                .foregroundColor(.red)
            VStack {
                HStack {
                    Text("11:35-13:05")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text("Программирование")
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text("Жуковский М.С")
                        .font(.footnote)
                    Spacer()
                    Text("315 ГК")
                        .font(.footnote)
                }
            }.padding(.leading, 5)
        }.padding()
    }
}

struct TodayWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TodayWidgetView()
    }
}
