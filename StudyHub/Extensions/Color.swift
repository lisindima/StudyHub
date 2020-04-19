//
//  Color.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 30.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

extension Color {
    static func rgb(red: Double, green: Double, blue: Double) -> Color {
        return Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0)
    }
    static let backroundColor = Color.rgb(red: 21.0, green: 22.0, blue: 33.0)
    static let outlineColor = Color.rgb(red: 54.0, green: 255.0, blue: 203.0)
    static let trackColor = Color.rgb(red: 45.0, green: 56.0, blue: 95.0)
    static let pulsatingColor = Color.rgb(red: 73.0, green: 113.0, blue: 148.0)
    static let defaultColorApp = Color(.systemIndigo)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let systemBackground = Color(UIColor.systemBackground)
}

extension View {
    func banner(isPresented: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(showBanner: isPresented))
    }
}
