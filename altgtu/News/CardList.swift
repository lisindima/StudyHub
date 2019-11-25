//
//  CardList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI

struct CardList: View {
    
    @ObservedObject var newsVM = NewsViewModel()
    
    func showNews(_ news: Articles) {
        if let url = URL(string: news.url!) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        Group {
            if newsVM.articles.isEmpty {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                                ActivityIndicator()
                            Spacer()
                        }
                    }
                    .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                    .navigationBarTitle(Text("Сегодня"))
                }
            } else {
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center) {
                            ScrollView(.horizontal, showsIndicators: false){
                               VStack (alignment: .leading){
                                   HStack{
                                       Button(action: {self.newsVM.fetchCategoryNews(category: "sports")}, label: {Text("Спорт")})
                                           .frame(width: 120, height: 110)
                                           .background(Color.red)
                                           .foregroundColor(.white)
                                           .cornerRadius(8)
                                       Button(action: {self.newsVM.fetchCategoryNews(category: "entertainment")}, label: {Text("Развлечение")})
                                           .frame(width: 120, height: 110)
                                           .background(Color.blue)
                                           .foregroundColor(.white)
                                           .cornerRadius(8)
                                       Button(action: {self.newsVM.fetchCategoryNews(category: "technology")}, label: {Text("Технологии")})
                                           .frame(width: 120, height: 110)
                                           .background(Color.green)
                                           .foregroundColor(.white)
                                           .cornerRadius(8)
                                       Button(action: {self.newsVM.fetchCategoryNews(category: "health")}, label: {Text("Здоровье")})
                                           .frame(width: 120, height: 110)
                                           .background(Color.purple)
                                           .foregroundColor(.white)
                                           .cornerRadius(8)
                                       Button(action: {self.newsVM.fetchCategoryNews(category: "business")}, label: {Text("Бизнес")})
                                       .frame(width: 120, height: 110)
                                       .background(Color.yellow)
                                       .foregroundColor(.white)
                                       .cornerRadius(8)
                                   }
                               }
                               .padding()
                            }
                            ForEach(self.newsVM.articles, id: \.self) { i in
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
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
