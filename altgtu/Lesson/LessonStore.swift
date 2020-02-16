//
//  LessonStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 08.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

class LessonStore: ObservableObject {
    
    @Published var scheduleModel: Schedules = [ScheduleModel]()
    
    let apiUrl = "https://gist.githubusercontent.com/lisindima/a15a61abb015ae38374bfb7a4e54cf2e/raw/c862faf545848ff135a6fcb5aa8b98b57d569b54/gistfile1.txt"
    
    func loadLesson() {
        AF.request(apiUrl)
        .validate()
        .responseDecodable(of: Schedules.self) { (response) in
          guard let schedule = response.value else { return }
            self.scheduleModel = schedule
        }
    }
}
