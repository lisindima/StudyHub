//
//  Privacy.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Privacy: View {
    
    private var urlSite: String = "https://lisindmitriy.me/privacyaltgtu/"
    
    var body: some View {
        WebView(urlSite: urlSite)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(Text("Политика конфиденциальности"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                UIApplication.shared.open(URL(string: "https://lisindmitriy.me/privacyaltgtu/")!)
            }) {
                Image(systemName: "safari")
                    .imageScale(.large)
            })
    }
}

struct Privacy_Previews: PreviewProvider {
    static var previews: some View {
        Privacy()
    }
}
