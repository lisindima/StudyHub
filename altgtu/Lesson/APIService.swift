//
//  APIService.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 08.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import SwiftUI

class APIService: ObservableObject {
    
    @Published var scheduleModel: Schedules = [ScheduleModel]()
    
    func loadLesson() {
        guard let url: URL = URL(string: "http://10.211.55.3/Infobase/hs/get/List/") else { return }
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

