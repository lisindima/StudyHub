//
//  WebView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Foundation
import WebKit

struct WebView: UIViewRepresentable {
    
    var urlSite: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlSite) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)
        return wkWebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
}

