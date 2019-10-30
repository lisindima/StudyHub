//
//  LessonWatch.swift
//  altgtuWatchApp Extension
//
//  Created by Дмитрий Лисин on 15.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LessonWatch: View {
    @Binding var signInSuccess: Bool
    var body: some View {
        List {
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
                
            Button("Выйти") {
                self.signInSuccess.toggle()
                print("hello watch")
            }
        }.listStyle(CarouselListStyle())
    }
}
