//
//  DateStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 13.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Combine
import Foundation

class DateStore: ObservableObject {
    static let shared = DateStore()

    let stringDate: String = {
        var currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
        let createStringDate = dateFormatter.string(from: currentDate)
        return createStringDate
    }()

    let dateHour: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    let dateDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
}
