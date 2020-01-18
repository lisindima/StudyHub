//
//  Extensions.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

extension Color {
    static func rgb(red: Double, green: Double, blue: Double) -> Color {
        return Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
    static let backroundColor = Color.rgb(red: 21, green: 22, blue: 33)
    static let outlineColor = Color.rgb(red: 54, green: 255, blue: 203)
    static let trackColor = Color.rgb(red: 45, green: 56, blue: 95)
    static let pulsatingColor = Color.rgb(red: 73, green: 113, blue: 148)
}
