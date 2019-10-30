//
//  Kabinet.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 14.09.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import WebKit

struct Kabinet : View {
    var body: some View {
            VStack {
                    WebView(request: URLRequest(url: URL(string:"https://student.altstu.ru")!))
                }
            .edgesIgnoringSafeArea(.top)
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context)
    {
        uiView.load(request)
    }
    
}

struct Kabinet_Previews: PreviewProvider {
    static var previews: some View {
        Kabinet()
    }
}
