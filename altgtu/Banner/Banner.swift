//
//  Banner.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    
    struct BannerData {
        var title: String
        var subtitle: String
    }
    
    @Binding var data: BannerData
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.subtitle)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                        CircleProgress()
                            .padding()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color.backroundColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .zIndex(1)
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
            }
            content
        }
    }

}

extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}
