//
//  ScheduleListWatch.swift
//  StudyHubWatchApp Extension
//
//  Created by Дмитрий Лисин on 15.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ScheduleListWatch: View {
    @ObservedObject private var scheduleStore = ScheduleStore.shared

    var body: some View {
        VStack {
            if scheduleStore.scheduleModel.isEmpty {
                ProgressView()
                    .onAppear(perform: scheduleStore.loadLesson)
            } else {
                List {
                    ForEach(self.scheduleStore.scheduleModel.sorted { $0.week < $1.week }, id: \.id) { schedule in
                        ScheduleItem(scheduleModel: schedule)
                    }
                }
                .listStyle(CarouselListStyle())
                .navigationBarTitle("Расписание")
            }
        }
    }
}
