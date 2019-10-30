//
//  Today.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Today : View {
    @EnvironmentObject var session: SessionStore
    @GestureState var dragState : DragState = .inactive
    var body: some View {
        let dragGesture = DragGesture()
            .updating($dragState) { (value, state, transc) in
                state = .dragging(translation: value.translation)
        }
        return ZStack {
            Card(title: "Третий")
                .blendMode(.hardLight)
                .padding(dragState.isActive ? 32 : 64)
                .padding(.bottom, dragState.isActive ? 32 : 64)
                .animation(.spring())
            Card(title: "Второй")
                .blendMode(.hardLight)
                .padding(dragState.isActive ? 16 : 32)
                .padding(.bottom, dragState.isActive ? 0 : 32)
                .animation(.spring())
            MainCard(title: "Первый")
            .rotationEffect(Angle(degrees: Double(dragState.translation.width / 10)))
            .offset(
                x: self.dragState.translation.width,
                y: self.dragState.translation.height
            )
            .gesture(dragGesture)
            .animation(.spring())
            .blendMode(.hardLight)
        }
    }
}
enum DragState {
    case inactive
    case dragging (translation: CGSize)
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    var isActive: Bool {
    switch self {
    case .inactive:
        return false
            case .dragging:
        return true
        }
    }
}
struct Card : View {
    var title : String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.init(red: 68 / 255, green: 41 / 255, blue: 182 / 255))
                .frame(height: 230)
                .cornerRadius(10)
                .padding(16)
            Text(title)
                .foregroundColor(Color.white)
                .font(.title)
                .bold()
        }
    }
}
struct MainCard : View {
    var title : String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(height: 230)
                .cornerRadius(10)
                .padding(16)
                Text(title)
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .bold()
                    }
                    .contextMenu {
                            Button(action: { print("Действие 1")}){
                            HStack {
                            Image(systemName: "star")
                            Text("Действие 1")
                }
            }
        }
    }
}

struct Today_Previews: PreviewProvider {
    static var previews: some View {
        Today()
    }
}
