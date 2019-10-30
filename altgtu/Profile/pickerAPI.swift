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
    
    @Published var modelPicker: ModelsPicker = [ModelPicker]()
    
    func loadPickerData() {
        guard let url: URL = URL(string: "https://my-json-server.typicode.com/lisindima/altgtuAPI/nameFaculty") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = data else { return }
                let swift = try JSONDecoder().decode(ModelsPicker.self, from: json)
                DispatchQueue.main.async {
                    self.modelPicker = swift
                }
            }
            catch {
                print(error)
            }
        }
        .resume()
    }
}
