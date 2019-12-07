//
//  ModelPicker.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

public struct GroupModelElement: Codable, Hashable, Identifiable {
    public let startYear: Int?
    public let name: String
    public let facultyID: String?
    public let specialityID: String?
    public let groupBr: Int?
    public let id: String
}

public typealias GroupModel = [GroupModelElement]
