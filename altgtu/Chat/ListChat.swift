//
//  ListChat.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 31.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ListChat: View {
    
    @EnvironmentObject var sessionChat: SessionChat
    
    func delete(at offsets: IndexSet) {
        sessionChat.chatList.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        sessionChat.chatList.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.sessionChat.chatList, id: \.self) { item in
                    NavigationLink(destination: ChatView(sessionChat: self._sessionChat, titleChat: item)) {
                        ListItem(sessionChat: self._sessionChat, nameChat: item)
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .navigationBarTitle(Text("Чат"))
            .navigationBarItems(leading: EditButton(), trailing: Button (action: {
                print("plus")
            })
            {
                Image(systemName: "plus.bubble")
                    .imageScale(.large)
            })
            
        }
    }
}


struct ListItem: View {
    
    @EnvironmentObject var sessionChat: SessionChat
    
    var nameChat: String
    var body: some View {
       HStack {
            Image("avatar")
               .resizable()
               .frame(width: 50, height: 50)
               .clipShape(Circle())
               .clipped()
            VStack(alignment: .leading) {
                Text(nameChat)
                    .bold()
                Text("Автор: сообщение")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}
