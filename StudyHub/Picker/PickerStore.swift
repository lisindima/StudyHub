//
//  PickerStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Alamofire
import Combine
import SwiftUI

class PickerStore: ObservableObject {
    @ObservedObject private var sessionStore = SessionStore.shared

    @Published var facultyModel = [FacultyModelElement]()
    @Published var groupModel = [GroupModelElement]()

    static let shared = PickerStore()
    let apiFaculty = "https://api.lisindmitriy.me/faculty"
    let apiGroup = "https://api.lisindmitriy.me/"

    func loadPickerFaculty() {
        AF.request(apiFaculty)
            .validate()
            .responseDecodable(of: [FacultyModelElement].self) { [self] response in
                switch response.result {
                case .success:
                    guard let faculty = response.value else { return }
                    facultyModel = faculty
                    loadPickerGroup()
                case let .failure(error):
                    print("Список факультет не загружен: \(error.errorDescription!)")
                }
            }
    }

    func loadPickerGroup() {
        AF.request(apiGroup + facultyModel[sessionStore.userData.choiseFaculty].id)
            .validate()
            .responseDecodable(of: [GroupModelElement].self) { [self] response in
                switch response.result {
                case .success:
                    guard let group = response.value else { return }
                    groupModel = group
                case let .failure(error):
                    print("Список групп не загружен: \(error.errorDescription!)")
                }
            }
    }
}

struct GroupModelElement: Identifiable, Codable {
    let id: String
    let startYear: Int?
    let name: String
    let facultyID: String?
    let specialityID: String?
    let groupBr: Int?
}

struct FacultyModelElement: Identifiable, Codable {
    let id: String
    let name: String
}
