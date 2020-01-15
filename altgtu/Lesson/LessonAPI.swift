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
    
    let apiUrl = "https://gist.githubusercontent.com/lisindima/a15a61abb015ae38374bfb7a4e54cf2e/raw/c862faf545848ff135a6fcb5aa8b98b57d569b54/gistfile1.txt"
    /*
    init() {
        loadLesson()
    }
    */
    
    func loadLesson() {
        guard let url = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            if response.statusCode == 200 {
                guard let json = data else { return }
                DispatchQueue.main.async {
                    do {
                        let swift = try JSONDecoder().decode(Schedules.self, from: json)
                        self.scheduleModel = swift
                    }
                    catch {
                        print(error)
                    }
                }
            }else{
                print("Lesson: \(response.statusCode)")
            }
        }.resume()
    }
}

