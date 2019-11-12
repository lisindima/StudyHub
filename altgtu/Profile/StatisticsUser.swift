//
//  StatisticsUser.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct StatisticsUser: View {
    
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Успеваемость", legend: "По дням")
                    .padding()
                /*
                HStack {
                    BarChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary")
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                    BarChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary")
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                }
                */
                Spacer()
            }
            .navigationBarTitle(Text("Статистика"), displayMode: .inline)
            .navigationBarItems(trailing: Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
            })
            {
                Text("Готово")
                    .bold()
                    //.foregroundColor(Color(red: session.rValue ?? 10, green: session.gValue ?? 10, blue: session.bValue ?? 10, opacity: 1.0))
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StatisticsUser_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsUser()
    }
}
