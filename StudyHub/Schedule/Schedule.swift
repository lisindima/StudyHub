//
//  Schedule.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Schedule: View {
    
    var scheduleModel: ScheduleModel
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 10)
                .foregroundColor(.accentColor)
            VStack {
                HStack {
                    Text(scheduleModel.time)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text(scheduleModel.name)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text("Жуковский М.C.")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    Spacer()
                    Text(scheduleModel.audit)
                        .font(.footnote)
                }
            }.padding(.leading, 5)
        }.padding()
    }
}
