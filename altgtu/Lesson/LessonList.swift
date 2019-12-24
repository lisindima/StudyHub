//
//  LessonList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct LessonList: View {

@ObservedObject var api: LessonAPI = LessonAPI()
    @State private var weakType: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $weakType) {
                    Text("1-ая неделя").tag(0)
                    Text("2-ая неделя").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
            if weakType == 0 {
                List {
                    ForEach(self.api.scheduleModel) { todo in
                        NavigationLink(destination: LessonDetail(model: todo)) {
                            Lesson(model: todo)
                        }
                    }
                }
            }
            if weakType == 1 {
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
