//
//  ChatView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 29.01.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var chatStore: ChatStore
    
    func loadChatData() {
        chatStore.getDataFromDatabaseListenChat()
        chatStore.loadMessageList()
    }
    
    var body: some View {
        Group {
            if chatStore.statusChat == .loading {
                ChatLoading()
                    .onAppear(perform: loadChatData)
            } else if chatStore.statusChat == .emptyChat {
                ChatEmpty()
            } else if chatStore.statusChat == .showChat {
                ChatList()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}