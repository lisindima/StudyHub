//
//  Payment.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 13.11.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Payment: View {
    
    @State private var donate: Int = 50
    @State private var active: Bool = false
    
    func activeButton() {
        if donate <= 55 {
            self.active = true
        } else {
            self.active = false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        self.activeButton()
                        self.donate = self.donate - 5
                    },
                    label: {
                        Image(systemName: "minus.circle")
                            .font(.largeTitle)
                }).disabled(active).padding(.leading, 40)
                Spacer()
                Text("\(donate) рублей")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(
                    action: {
                        self.activeButton()
                        self.donate = self.donate + 5
                    },
                    label: {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                }).padding(.trailing, 40)
            }.padding(.top, 40)
            Spacer()
        }.onAppear(perform: activeButton)
    }
}

struct Payment_Previews: PreviewProvider {
    static var previews: some View {
        Payment()
    }
}
