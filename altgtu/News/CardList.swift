//
//  CardList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct CardList: View {
    
    @ObservedObject var newsAPI: NewsAPI = NewsAPI()
    
    func showNews(_ news: Article) {
        if let url = URL(string: news.url!) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    ForEach(self.newsAPI.articles, id: \.self) { i in
                        CardView(article: i)
                            .onTapGesture {
                                self.showNews(i)
                            }
                            .contextMenu {
                                Button(action:
                                    {
                                        self.showNews(i)
                                    }){
                                        HStack {
                                            Image(systemName: "globe")
                                            Text("Открыть")
                            }
                        }
                    }
                }
            }
        }
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
        .navigationBarTitle(Text("Сегодня"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
