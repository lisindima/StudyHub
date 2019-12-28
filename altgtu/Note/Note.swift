//
//  Note.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 26.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Note: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Заметки")
            }
            .navigationBarTitle(Text("Заметки"))
            .navigationBarItems(leading: EditButton(), trailing: Button (action: {
                print("plus")
            })
            {
                Image(systemName: "square.and.pencil")
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
