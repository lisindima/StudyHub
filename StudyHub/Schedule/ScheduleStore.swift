//
//  ScheduleStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 08.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Alamofire
import Combine
import SwiftUI

class ScheduleStore: ObservableObject {
    @Published var scheduleModel: [ScheduleModel] = [ScheduleModel]()
    @Published var scheduleLoadingFailure: Bool = false

    static let shared = ScheduleStore()

    func loadLesson() {
        AF.request("https://api.lisindmitriy.me/schedule")
            .validate()
            .responseDecodable(of: [ScheduleModel].self) { response in
                switch response.result {
                case .success:
                    guard let schedule = response.value else { return }
                    self.scheduleModel = schedule
                case let .failure(error):
                    self.scheduleLoadingFailure = true
                    print("Расписание группы не загружен: \(error.errorDescription!)")
                }
            }
    }
}

struct ScheduleModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    var week: Int
    var dayOfWeek: String
    var name: String
    var audit: String
    var time: String
}
