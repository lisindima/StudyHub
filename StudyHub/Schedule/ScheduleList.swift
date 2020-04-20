//
//  ScheduleList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ScheduleList: View {
    
    @ObservedObject private var scheduleStore: ScheduleStore = ScheduleStore.shared
    @State private var week: Int = 1
    
    var body: some View {
        NavigationView {
            if scheduleStore.scheduleModel.isEmpty {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear(perform: scheduleStore.loadLesson)
                    .navigationBarTitle("Расписание")
            } else {
                VStack {
                    Picker("", selection: $week) {
                        Text("1-ая неделя").tag(1)
                        Text("2-ая неделя").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                    .padding(.horizontal)
                    if week == 1 {
                        List {
                            ForEach(self.scheduleStore.scheduleModel.sorted { $0.week < $1.week }, id: \.id) { schedule in
                                Schedule(scheduleModel: schedule)
                            }
                        }
                    }
                    if week == 2 {
                        List {
                            ForEach(self.scheduleStore.scheduleModel.sorted { $0.week > $1.week }, id: \.id) { schedule in
                                Schedule(scheduleModel: schedule)
                            }
                        }
                    }
                }.navigationBarTitle("Расписание")
            }
        }
    }
}

struct LessonList_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleList()
    }
}
