//
//  CircleProgress.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 13.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct CircleProgress: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        VStack {
            ZStack {
                Pulsation()
                Track()
                Label(percentage: sessionStore.percentComplete)
                Outline(percentage: sessionStore.percentComplete)
            }
        }
    }
}

struct Label: View {
    
    var percentage: Double = 0.0
    
    var body: some View {
        ZStack {
            Text(String(format: "%.0f", CGFloat(percentage)))
                .font(.system(size: 18))
                .fontWeight(.heavy)
                .foregroundColor(.white)
        }.animation(nil)
    }
}

struct Outline: View {
    
    var percentage: Double = 0.0
    var colors: [Color] = [Color.outlineColor]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .trim(from: 0, to: CGFloat(percentage) * 0.01)
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .fill(AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .init(degrees: 360)))
                        .rotationEffect(.degrees(-90))
            ).animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0))
        }
    }
}

struct Track: View {
    
    var colors: [Color] = [Color.trackColor]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.backroundColor)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 8))
                        .fill(AngularGradient(gradient: .init(colors: colors), center: .center))
            )
        }
    }
}

struct Pulsation: View {
    
    @State private var pulsate: Bool = false
    
    var colors: [Color] = [Color.pulsatingColor]
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.pulsatingColor)
                .frame(width: 60, height: 60)
                .scaleEffect(pulsate ? 1.3 : 1.1)
                .animation(Animation.easeInOut(duration: 1.1).repeatForever(autoreverses: true))
                .onAppear {
                    self.pulsate.toggle()
            }
        }
    }
}
