//
//  Banner.swift
//  altgtu
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
                                .bold()
                            Text("Нажмите для скрытия уведомления")
                                .font(Font.system(size: 12, weight: Font.Weight.light, design: Font.Design.default))
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
                .padding(.top, 40)
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

extension View {
    func banner(isPresented: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(showBanner: isPresented))
    }
}
