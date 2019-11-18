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
        
    var body: some View {
        VStack {
            HStack {
                LottieView(filename: "3509-coffee-and-biscuit")
                    .frame(width: 400, height: 400)
            }
            HStack {
                if donate <= 50 {
                    Button(
                        action: {
                            self.donate = self.donate - 10
                        },
                        label: {
                            Image(systemName: "minus.circle")
                                .font(.largeTitle)
                    }).disabled(true).padding(.leading, 40)
                } else {
                    Button(
                        action: {
                            self.donate = self.donate - 10
                        },
                        label: {
                            Image(systemName: "minus.circle")
                                .font(.largeTitle)
                    }).padding(.leading, 40)
                }
                Spacer()
                Text("\(donate) рублей")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(
                    action: {
                        self.donate = self.donate + 10
                    },
                    label: {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                }).padding(.trailing, 40)
            }.padding(.top)
            Spacer()
        }
    }
}

struct Payment_Previews: PreviewProvider {
    static var previews: some View {
        Payment()
    }
}
