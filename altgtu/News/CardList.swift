//
//  CardList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import URLImage

struct CardList: View {
    
    @ObservedObject var newsApi = NewsAPI()
    @EnvironmentObject var session: SessionStore
    @State private var showDetailsNews: Bool = false
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    var currentDate = Date()
    
    func showNewsSafari(_ news: Articles) {
        if let url = URL(string: news.url!) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        Group {
            if newsApi.articles.isEmpty {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                ActivityIndicator()
                                    .onAppear(perform: newsApi.loadNews)
                                Text("ЗАГРУЗКА")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }.frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                }.navigationViewStyle(StackNavigationViewStyle())
            } else {
                ScrollView(showsIndicators: false) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(currentDate, formatter: dateFormatter)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Сегодня")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                        }
                            .padding(.leading, 15)
                        Spacer()
                        URLImage(URL(string:"\(session.urlImageProfile ?? "https://icon-library.net/images/no-image-icon/no-image-icon-13.jpg")")!, incremental : false, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                            ProgressView($0) { progress in
                                ZStack {
                                    if progress > 0.0 {
                                        ActivityIndicator()
                                    } else {
                                        ActivityIndicator()
                                    }
                                }
                            }
                                .padding(.trailing, 15)
                                .frame(width: 45, height: 45)
                            }) { proxy in
                                    proxy.image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 45, height: 45)
                                        .padding(.trailing, 15)
                            }
                        }.padding(.top, 30)
                        VStack(alignment: .center) {
                            ScrollView(.horizontal, showsIndicators: false){
                               VStack (alignment: .leading){
                                   HStack{
                                        Button(action: {self.newsApi.fetchCategoryNews(category: "")}, label: {Text("Популярное")
                                            .frame(width: 120, height: 110)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)})
                                        Divider()
                                            .frame(height: 90)
                                            .padding(.horizontal, 8)
                                        Button(action: {self.newsApi.fetchCategoryNews(category: "&category=sports")}, label: {Text("Спорт")
                                            .frame(width: 120, height: 110)
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)})
                                        Button(action: {self.newsApi.fetchCategoryNews(category: "&category=entertainment")}, label: {Text("Развлечение")
                                            .frame(width: 120, height: 110)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)})
                                        Button(action: {self.newsApi.fetchCategoryNews(category: "&category=technology")}, label: {Text("Технологии")
                                            .frame(width: 120, height: 110)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)})
                                        Button(action: {self.newsApi.fetchCategoryNews(category: "&category=health")}, label: {Text("Здоровье")
                                            .frame(width: 120, height: 110)
                                            .background(Color.purple)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)})
                                        Button(action: {self.newsApi.fetchCategoryNews(category: "&category=business")}, label: {Text("Бизнес")
                                            .frame(width: 120, height: 110)
                                            .background(Color.yellow)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)})
                                    }
                                }.padding()
                            }
                            ForEach(self.newsApi.articles, id: \.self) { i in
                                CardView(article: i)
                                    .onTapGesture {
                                        self.showDetailsNews = true
                                    }
                                    .sheet(isPresented: self.$showDetailsNews, onDismiss: {
                                    
                                    }, content: {
                                        DetailsNews(article: i)
                                    })
                                    .contextMenu {
                                        Button(action:
                                            {
                                                self.showNewsSafari(i)
                                        }){
                                            HStack {
                                                Image(systemName: "safari")
                                                Text("Открыть в Safari")
                                    }
                                }
                            }
                        }
                    }
                }.frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            }
        }
    }
}
