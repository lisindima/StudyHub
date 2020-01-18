//
//  Lesson.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Lesson: View {
    
    var model: ScheduleModel
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 10)
                .foregroundColor(.red)
            VStack {
                HStack {
                    Text("\(model.timeStart)-\(model.timeEnd)")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.red)
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text(model.name)
                        .bold()
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text(model.prepod)
                        .font(.footnote)
                    Spacer()
                    Text(model.audit)
                        .font(.footnote)
                }
                
            }.padding(.leading, 5)
        }
        .padding()
        .contextMenu {
            Button(action: {
                print("Действие 1")
            }) {
                HStack {
                    Image(systemName: "star")
                    Text("Действие 1")
                }
            }
        }
    }
}
