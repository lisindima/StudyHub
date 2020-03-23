//
//  PickerStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import Firebase
import Alamofire

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
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    let apiFaculty = "https://api.lisindmitriy.me/faculty"
    let apiGroup = "https://api.lisindmitriy.me/"
    
    func loadPickerFaculty() {
        AF.request(apiFaculty)
            .validate()
            .responseDecodable(of: FacultyModel.self) { response in
                switch response.result {
                case .success( _):
                    guard let faculty = response.value else { return }
                    self.facultyModel = faculty
                    self.loadPickerGroup()
                case .failure(let error):
                    print("Список факультет не загружен: \(error.errorDescription!)")
                }
        }
    }
    
    func loadPickerGroup() {
        AF.request(apiGroup + facultyModel[choiseFaculty].id)
            .validate()
            .responseDecodable(of: GroupModel.self) { response in
                switch response.result {
                case .success( _):
                    guard let group = response.value else { return }
                    self.groupModel = group
                case .failure(let error):
                    print("Список групп не загружен: \(error.errorDescription!)")
                }
        }
    }
    
    func getDataFromDatabaseListenPicker() {
        db.collection("profile").document(currentUser!.uid).addSnapshotListener { documentSnapshot, error in
            if let document = documentSnapshot {
                self.choiseGroup = document.get("choiseGroup") as! Int
                self.choiseFaculty = document.get("choiseFaculty") as! Int
            } else if error != nil {
                print((error?.localizedDescription)!)
            }
        }
    }
    
    func updateDataFromDatabasePicker() {
        let docRef = db.collection("profile").document(currentUser!.uid)
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
