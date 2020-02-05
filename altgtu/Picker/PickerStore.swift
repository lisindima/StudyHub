//
//  PickerStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Firebase

class PickerStore: ObservableObject {
    
    @Published var facultyModel: FacultyModel = [FacultyModelElement]()
    @Published var groupModel: GroupModel = [GroupModelElement]()
    @Published var choiseGroup: Int = 0
    
    var choiseFaculty: Int = 0 {
        didSet {
            if !facultyModel.isEmpty {
                loadPickerGroup()
            }
        }
    }

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
        guard let url = URL(string: apiGroup + facultyModel[choiseFaculty].id) else { return }
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
    
    func getDataFromDatabaseListenPicker() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        db.collection("profile").document(currentUser.uid).addSnapshotListener { documentSnapshot, error in
            if let document = documentSnapshot {
                self.choiseGroup = document.get("choiseGroup") as! Int
                self.choiseFaculty = document.get("choiseFaculty") as! Int
                print("\(self.choiseGroup) группа выбрана")
                print("\(self.choiseFaculty) факультет выбран")
            } else if error != nil {
                print((error?.localizedDescription)!)
            }
        }
    }
    
    func updateDataFromDatabasePicker() {
        let currentUser = Auth.auth().currentUser!
        let db = Firestore.firestore()
        let docRef = db.collection("profile").document(currentUser.uid)
        docRef.updateData([
            "choiseGroup": choiseGroup,
            "choiseFaculty": choiseFaculty
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Пикеры обновлены")
            }
        }
    }
}
