//
//  ModelPicker.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

public struct GroupModelElement: Codable, Hashable {
    public let startYear: Int?
    public let name: String?
    public let facultyID: String?
    public let specialityID: String?
    public let groupBr: Int?
    public let id: String?

    enum CodingKeys: String, CodingKey {
        case startYear
        case name
        case facultyID
        case specialityID
        case groupBr
        case id
    }

    public init(startYear: Int?, name: String?, facultyID: String?, specialityID: String?, groupBr: Int?, id: String?) {
        self.startYear = startYear
        self.name = name
        self.facultyID = facultyID
        self.specialityID = specialityID
        self.groupBr = groupBr
        self.id = id
    }
}

public typealias GroupModel = [GroupModelElement]
