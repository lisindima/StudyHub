//
//  ModelLesson.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 08.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

struct ScheduleModel: Codable, Identifiable {
    let id: Int
    let name: String
    let prepod: String
    let timeStart: String
    let timeEnd: String
    let audit: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "Name"
        case prepod = "Prepod"
        case timeStart = "TimeStart"
        case timeEnd = "TimeEnd"
        case audit = "Audit"
    }
}

typealias Schedules = [ScheduleModel]
