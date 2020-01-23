//
//  ModelPicker.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

struct GroupModelElement: Codable, Hashable, Identifiable {
    let startYear: Int?
    let name: String
    let facultyID: String?
    let specialityID: String?
    let groupBr: Int?
    let id: String
}

typealias GroupModel = [GroupModelElement]
