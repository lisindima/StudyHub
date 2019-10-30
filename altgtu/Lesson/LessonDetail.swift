//
//  LessonDetail.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 23.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LessonDetail: View {
    var model: ScheduleModel
    var body: some View {
        Group {
            Text(model.name)
            Text(model.prepod)
            Text(model.audit)
            Text(model.timeStart)
            Text(model.timeEnd)
        }
    }
}
