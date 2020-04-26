//
//  Banner.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 13.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    
    @Binding var showBanner: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if showBanner {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Загрузка")
                                .fontWeight(.bold)
                            Text("Нажмите, чтобы закрыть.")
                                .font(.system(size: 12, weight: .light, design: .default))
                        }
                        Spacer()
                        CircleProgress()
                    }
                    .foregroundColor(Color.white)
                    .padding(16)
                    .background(Color.backroundColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .zIndex(1)
                .padding(.horizontal)
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.showBanner = false
                    }
                }
            }
            content
        }
    }
}
