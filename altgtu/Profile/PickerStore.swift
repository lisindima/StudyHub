//
//  PickerStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine

class PickerStore: ObservableObject {
    
    @Published var groupModel: GroupModel = [GroupModelElement]()
    
    static let shared = PickerStore()
    
    let apiUrl = "https://gist.githubusercontent.com/lisindima/a3246c9eebae2e152c1f8211d10d4255/raw/30ee8647261b839c3a00024a851a340295300787/group"
    
    func loadPickerDataGroup() {
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
                        let swift = try JSONDecoder().decode(GroupModel.self, from: json)
                        self.groupModel = swift
                        print("Данные групп загружены")
                    } catch {
                        print(error)
                    }
                }
            } else {
                print("Picker: \(response.statusCode)")
            }
        }.resume()
    }
}
