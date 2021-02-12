//
//  Date.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 13.03.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import Foundation

var stringDate: String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
    let createStringDate = dateFormatter.string(from: currentDate)
    return createStringDate
}

var dateHour: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}

var dateDay: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter
}
