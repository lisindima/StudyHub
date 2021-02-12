//
//  Color.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 30.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

extension Color {
    static func rgb(red: Double, green: Double, blue: Double) -> Color {
        Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
    }

    static let defaultColorApp = Color(.systemIndigo)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let systemBackground = Color(UIColor.systemBackground)
}
