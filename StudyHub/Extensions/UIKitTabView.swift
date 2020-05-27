//
//  UIKitTabView.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 27.05.2020.
//  Copyright © 2020 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct TabBarController: UIViewControllerRepresentable {
    
    var controllers: [UIViewController]
    
    @Binding var selectedIndex: Int
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = 0
        return tabBarController
    }
    
    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController
        
        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedIndex = tabBarController.selectedIndex
        }
    }
}

struct UIKitTabView: View {
    
    var viewControllers: [UIHostingController<AnyView>]
    
    @State var selectedIndex: Int = 0
    
    init(@TabBuilder _ views: () -> [Tab]) {
        self.viewControllers = views().map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
    }
    
    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        init<V: View>(title: String?, image: String? = nil, selectedImage: String? = nil, content: () -> V) {
            let selectedImage = selectedImage != nil ? UIImage(named: selectedImage!) ?? UIImage(systemName: selectedImage!) : nil
            let barItem = UITabBarItem(title: title, image: image != nil ? UIImage(named: image!) ?? UIImage(systemName: image!) : nil, selectedImage: selectedImage)
            self.init(view: content(), barItem: barItem)
        }
    }
}

@_functionBuilder
struct TabBuilder {
    static func buildBlock(_ items: UIKitTabView.Tab...) -> [UIKitTabView.Tab] {
        items
    }
}

extension View {
    func tab(title: String, image: String? = nil, selectedImage: String? = nil) -> UIKitTabView.Tab {
        UIKitTabView.Tab(title: title, image: image, selectedImage: selectedImage) {
            self
        }
    }
}
