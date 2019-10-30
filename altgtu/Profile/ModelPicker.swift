//
//  ModelPicker.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 12.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

public class ModelPicker: Codable, Identifiable {
    public let name: String
    public let group: [group]

        public init(name: String, group: [group]) {
            self.name = name
            self.group = group
        }
    }

    public class group: Codable, Identifiable {
        public let name: String

        public init(name: String) {
            self.name = name
        }
    }

public typealias ModelsPicker = [ModelPicker]

