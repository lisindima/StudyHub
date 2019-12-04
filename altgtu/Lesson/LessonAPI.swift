//
//  LessonAPI.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 08.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import SwiftUI

class LessonAPI: ObservableObject {
    
    @Published var scheduleModel: Schedules = [ScheduleModel]()
    
    init() {
        loadLesson()
    }
    func loadLesson() {
        guard let url: URL = URL(string: "https://gist.githubusercontent.com/lisindima/a15a61abb015ae38374bfb7a4e54cf2e/raw/c862faf545848ff135a6fcb5aa8b98b57d569b54/gistfile1.txt") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = data else { return }
                let swift = try JSONDecoder().decode(Schedules.self, from: json)
                DispatchQueue.main.async {
                    self.scheduleModel = swift
                }
            }
            catch {
                print(error)
            }
        }
        .resume()
    }
}

