//
//  ScheduleListWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 15.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Espera

struct ScheduleListWatch: View {
    
    @ObservedObject var scheduleStore: ScheduleStore = ScheduleStore.shared
    
    var body: some View {
        VStack {
            if scheduleStore.scheduleModel.isEmpty {
                LoadingFlowerView()
                    .onAppear(perform: scheduleStore.loadLesson)
            } else {
                List {
                    ForEach(self.scheduleStore.scheduleModel.sorted { $0.week < $1.week }, id: \.id) { schedule in
                        Schedule(scheduleModel: schedule)
                    }
                }
                .listStyle(CarouselListStyle())
                .navigationBarTitle(Text("Расписание"))
            }
        }
    }
}
