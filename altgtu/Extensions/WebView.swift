//
//  WebView.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 09.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    @Binding var showActivityIndicator: Bool
    var urlSite: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlSite) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)
        wkWebView.navigationDelegate = context.coordinator
        return wkWebView
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.showActivityIndicator = true
            print("Загрузка началась")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.showActivityIndicator = false
            print("Загрузка закончилась")
        }
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
}
