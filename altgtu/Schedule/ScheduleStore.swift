//
//  ScheduleStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 08.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

class ScheduleStore: ObservableObject {
    
    @Published var scheduleModel: ScheduleModel = [ScheduleModelElement]()
    
    static let shared = ScheduleStore()
    
    func loadLesson() {
        AF.request("https://api.lisindmitriy.me/schedule")
        .validate()
        .responseDecodable(of: ScheduleModel.self) { (response) in
          guard let schedule = response.value else { return }
            self.scheduleModel = schedule
            print("Расписание группы загружено")
        }
    }
}

struct ScheduleModelElement: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let week: Int
    let dayOfWeek: String
    let name: String
    let audit: String
    let time: String
}

typealias ScheduleModel = [ScheduleModelElement]