//
//  Privacy.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct Privacy: View {
    
    @State private var showActivityIndicator: Bool = true
    private var urlSite: String = "https://lisindmitriy.me/privacyaltgtu/"
    
    var body: some View {
        ZStack {
            WebView(showActivityIndicator: $showActivityIndicator, urlSite: urlSite)
            ActivityIndicator(styleSpinner: .large)
                .opacity(showActivityIndicator ? 1.0 : 0.0)
        }
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
