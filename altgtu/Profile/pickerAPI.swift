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
        
    init() {
        loadPickerData()
    }
    
    func loadPickerData() {
        guard let url: URL = URL(string: "https://gist.githubusercontent.com/lisindima/a3246c9eebae2e152c1f8211d10d4255/raw/30ee8647261b839c3a00024a851a340295300787/group") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = data else { return }
                let swift = try JSONDecoder().decode(GroupModel.self, from: json)
                DispatchQueue.main.async {
                    self.groupModel = swift
                    print(self.groupModel)
                }
            }
            catch {
                print(error)
            }
        }
        .resume()
    }
}
