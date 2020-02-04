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
    
    @Published var facultyModel: FacultyModel = [FacultyModelElement]()
    @Published var groupModel: GroupModel = [GroupModelElement]()

    static let shared = PickerStore()
    
    let apiFaculty = "https://altstuapi.herokuapp.com/faculty"
    let apiGroup = "https://altstuapi.herokuapp.com/"
    
    func loadPickerFaculty() {
        guard let url = URL(string: apiFaculty) else { return }
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
                        let swift = try JSONDecoder().decode(FacultyModel.self, from: json)
                        self.facultyModel = swift
                        self.loadPickerGroup()
                        print("Данные факультетов загружены")
                    } catch {
                        print(error)
                    }
                }
            } else {
                print("Picker: \(response.statusCode)")
            }
        }.resume()
    }
    
    func loadPickerGroup() {
        guard let url = URL(string: apiGroup + facultyModel[7].id) else { return }
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
                        print("\(url)")
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
