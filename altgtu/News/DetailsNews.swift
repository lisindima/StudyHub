//
//  DetailsNews.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 20.12.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage

struct DetailsNews: View {
    
    @State private var showPopover: Bool = false
    @State private var sizeFont: Double = 20.0
    
    var article: Articles
    let noImageUrl = "https://firebasestorage.googleapis.com/v0/b/altgtu-46659.appspot.com/o/placeholder%2Fplaceholder.jpeg?alt=media&token=8f554741-2bfb-41ef-82b0-fbc64f0ffdf6"
    
    var body: some View {
        NavigationView {
            VStack {
                URLImage(URL(string: article.urlToImage ?? noImageUrl)!, incremental : true, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: { _ in
                    EmptyView()
                },
                content:
                { proxy in
                    proxy.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Text(article.description ?? "Описание отсутствует")
                    .font(.system(size: CGFloat(sizeFont)))
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.showPopover = true
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }.popover(
                        isPresented: self.$showPopover,
                        arrowEdge: .top
                    ) {
                        Slider(value: self.$sizeFont, in: 10.0...50.0)
                            .padding(.horizontal)
                    }
                }
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
