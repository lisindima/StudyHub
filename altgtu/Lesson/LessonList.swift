//
//  LessonList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LessonList: View {

@ObservedObject var api: APIService = APIService()
@State private var WeakType = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $WeakType) {
                    Text("1-ая неделя").tag(1)
                    Text("2-ая неделя").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
            if WeakType == 1 {
                List {
                    ForEach(self.api.scheduleModel) { todo in
                        NavigationLink(destination: LessonDetail(model: todo)) {
                            Lesson(model: todo)
                        }
                    }
                }
            }
            if WeakType == 2 {
                List {
                    Text("Beep")
                    Text("Beep")
                    }
                }
            }
            .navigationBarTitle(Text("Расписание"))
        }
    }
}

struct LessonList_Previews: PreviewProvider {
    static var previews: some View {
        LessonList()
    }
}
