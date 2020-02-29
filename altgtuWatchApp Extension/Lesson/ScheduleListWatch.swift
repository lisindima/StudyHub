//
//  ScheduleListWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 15.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ScheduleListWatch: View {
    
    @ObservedObject var scheduleStore: ScheduleStore = ScheduleStore.shared
    @Binding var signInSuccess: Bool
    
    var body: some View {
        List {
            ForEach(self.scheduleStore.scheduleModel.sorted { $0.week < $1.week }, id: \.id) { schedule in
                Schedule(scheduleModel: schedule)
            }
            Button("Выйти") {
                self.signInSuccess.toggle()
                print("hello watch")
            }
        }
        .listStyle(CarouselListStyle())
        .navigationBarTitle(Text("Расписание"))
        .onAppear(perform: scheduleStore.loadLesson)
    }
}