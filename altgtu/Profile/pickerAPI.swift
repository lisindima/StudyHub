//
//  pickerAPI.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine

class pickerAPI: ObservableObject {
    
    @Published var groupModel: GroupModel = [GroupModelElement]()
    @Published var groupModelEleme: [GroupModelElement] = []
    
    init() {
        loadPickerData()
    }
    
    func loadPickerData() {
        guard let url: URL = URL(string: "https://www.altstu.ru/main/schedule/ws/group/?f=74") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = data else { return }
                let swift = try JSONDecoder().decode(GroupModel.self, from: json)
                DispatchQueue.main.async {
                    self.groupModelEleme = swift
                    print(self.groupModelEleme)
                }
            }
            catch {
                print(error)
            }
        }
        .resume()
    }
}
