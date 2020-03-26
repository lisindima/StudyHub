//
//  CardList.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CardList: View {
    
    @ObservedObject var newsStore: NewsStore = NewsStore.shared
    @ObservedObject var dateStore: DateStore = DateStore.shared
    @EnvironmentObject var sessionStore: SessionStore
    
    @State private var showDetailsNews: Bool = false
    @State private var selectedTab: String = "Популярное"
    @State private var newsTopic: [String] = ["Популярное", "Спорт", "Развлечение", "Бизнес", "Здоровье", "Технологии"]
    
    var body: some View {
        NavigationView {
            if newsStore.articles.isEmpty {
                ActivityIndicator(styleSpinner: .large)
                    .onAppear(perform: newsStore.loadNews)
            } else {
                ScrollView(showsIndicators: false) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(dateStore.stringDate)".uppercased())
                                .font(.system(size: 13))
                                .bold()
                                .foregroundColor(.secondary)
                                .padding(.bottom, 3)
                            Text("Сегодня")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                        }.padding(.leading, 15)
                        Spacer()
                        KFImage(URL(string: sessionStore.urlImageProfile)!)
                            .placeholder { ActivityIndicator(styleSpinner: .medium) }
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                            .padding(.trailing, 15)
                    }.padding(.top, 30)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(newsTopic, id: \.self) { item in
                                Button(action: {
                                    self.selectedTab = item
                                    if item == "Популярное" {
                                        self.newsStore.fetchCategoryNews(category: "")
                                    } else if item == "Спорт" {
                                        self.newsStore.fetchCategoryNews(category: "&category=sports")
                                    } else if item == "Развлечение" {
                                        self.newsStore.fetchCategoryNews(category: "&category=entertainment")
                                    } else if item == "Технологии" {
                                        self.newsStore.fetchCategoryNews(category: "&category=technology")
                                    } else if item == "Здоровье" {
                                        self.newsStore.fetchCategoryNews(category: "&category=health")
                                    } else if item == "Бизнес" {
                                        self.newsStore.fetchCategoryNews(category: "&category=business")
                                    }
                                }) {
                                    VStack {
                                        Text(item)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                            .hoverEffect()
                                        Capsule()
                                            .fill(self.selectedTab == item ? Color.rgb(red: self.sessionStore.rValue, green: self.sessionStore.gValue, blue: self.sessionStore.bValue) : Color.clear)
                                            .frame(height: 6)
                                    }.frame(width: 110)
                                }
                            }
                        }.padding(.horizontal)
                    }
                    ForEach(self.newsStore.articles, id: \.id) { item in
                        NavigationLink(destination: DetailsNews(article: item)) {
                            CardView(article: item)
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
    }
}
