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
            Image("avatar")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .clipped()
            VStack {
                HStack {
                    Text("\(model.timeStart)-\(model.timeEnd)")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.red)
                    Spacer()
                }
                HStack {
                    Text(model.name)
                        .bold()
                Spacer()
                }
                HStack {
                    Text(model.prepod)
                    .font(.footnote)
                        Spacer()
                    Text(model.audit)
                        .font(.footnote)
                }
            
            }
        }.padding()
            .contextMenu {
                Button(action: { print("Действие 1")}){
                    HStack {
                    Image(systemName: "star")
                    Text("Действие 1")
                }
            }
        }
        .background(Color.green)
        .cornerRadius(16.0)
    }
}

