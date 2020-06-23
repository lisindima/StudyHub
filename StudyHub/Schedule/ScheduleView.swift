//
//  ScheduleView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 28.04.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    
    @ObservedObject private var scheduleStore: ScheduleStore = ScheduleStore.shared
    
    var body: some View {
        Group {
            if scheduleStore.scheduleModel.isEmpty {
                NavigationView {
                    ProgressView()
                        .onAppear(perform: scheduleStore.loadLesson)
                        .navigationBarTitle("Расписание")
                }.navigationViewStyle(StackNavigationViewStyle())
            } else {
                ScheduleList()
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
