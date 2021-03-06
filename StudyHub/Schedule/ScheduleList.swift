//
//  ScheduleList.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ScheduleList: View {
    @ObservedObject private var scheduleStore = ScheduleStore.shared
    @State private var week: Int = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $week) {
                    Text("1-ая неделя").tag(1)
                    Text("2-ая неделя").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .padding(.horizontal)
                List {
                    ForEach(scheduleStore.scheduleModel.sorted { week == 1 ? $0.week < $1.week :  $0.week > $1.week }, id: \.id) { schedule in
                        ScheduleItem(scheduleModel: schedule)
                    }
                }
            }
        }.navigationBarTitle("Расписание")
    }
}

struct LessonList_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleList()
    }
}
