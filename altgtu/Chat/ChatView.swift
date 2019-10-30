//
//  ChatView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 18.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KeyboardObserving

struct ChatView: View {
    @State private var message: String = ""
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text("ddd")
                }
                Spacer()
            HStack {
                CustomInput(text: $message, name: "Введите сообщение")
                if message.isEmpty == false {
                    Button(action:{
                        
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }.padding()
            }
            .keyboardObserving()
            .navigationBarTitle(Text("Чат"), displayMode: .inline)
            .navigationBarItems(trailing: Button (action: {
                    print("plus")
                })
                {
                    Image(systemName: "plus.bubble")
                        .imageScale(.large)
            })
            
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
