//
//  InfoPageView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import ConcentricOnboarding

struct InfoPageView: View {
    var body: some View {
            let pages = (0...3).map { i in
                AnyView(InfoPage(title: MockData.title, imageName: MockData.imageNames[i], header: MockData.headers[i], content: MockData.contentStrings[i], textColor: MockData.textColors[i]))
            }
            return ConcentricOnboardingView(pages: pages, bgColors: MockData.colors)
    }
}
