//
//  Note.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import FloatingButton

struct Note: View {
    
    let textButtons = (0..<ButtonData.iconAndTextTitles.count).reversed().map { i in
        AnyView(IconAndTextButton(imageName: ButtonData.iconAndTextImageNames[i], buttonText: ButtonData.iconAndTextTitles[i]))
    }

    let mainButton = AnyView(MainButton(imageName: "heart.fill", colorHex: "eb3b5a", width: 60))
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    ScrollView {
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                        Text("ЗаметкиЗаметкиЗаметкиЗаметки")
                    }
                    VStack {
                        Spacer()
                            .layoutPriority(10)
                        HStack {
                            Spacer()
                                .layoutPriority(10)
                            FloatingButton(mainButtonView: mainButton, buttons: textButtons)
                                .straight()
                                .direction(.top)
                                .alignment(.right)
                                .spacing(10)
                                .initialOpacity(0)
                        }.padding(20)
                    }
                }
            }
            .navigationBarTitle(Text("Заметки"))
            .navigationBarItems(leading: EditButton(), trailing: Button (action: {
                print("plus")
            })
            {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .imageScale(.large)
            })
        }
    }
}

struct Note_Previews: PreviewProvider {
    static var previews: some View {
        Note()
    }
}
