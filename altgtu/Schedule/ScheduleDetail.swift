//
//  ScheduleDetail.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 23.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ScheduleDetail: View {
    var scheduleModel: ScheduleModelElement
    var body: some View {
        VStack {
            Text(scheduleModel.name)
            Text(scheduleModel.audit)
            Text(scheduleModel.time)
        }
    }
}
