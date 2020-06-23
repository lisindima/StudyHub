//
//  NoteLoading.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 27.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct NoteLoading: View {
    var body: some View {
        NavigationView {
            ProgressView()
                .navigationBarTitle("Заметки")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NoteLoading_Previews: PreviewProvider {
    static var previews: some View {
        NoteLoading()
    }
}
