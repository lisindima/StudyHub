//
//  CardList.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct CardList: View {
    @ObservedObject private var newsStore = NewsStore.shared
    @ObservedObject private var dateStore = DateStore.shared

    @EnvironmentObject var sessionStore: SessionStore

    @State private var showDetailsNews: Bool = false
    @State private var selectedTab: String = "Популярное"
    @State private var newsTopic: [String] = ["Популярное", "Спорт", "Развлечение", "Бизнес", "Здоровье", "Технологии"]

    var body: some View {
        NavigationView {
            if newsStore.articles.isEmpty {
                ProgressView()
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
                        KFImage(URL(string: sessionStore.userData.urlImageProfile))
                            .placeholder { ProgressView() }
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                            .padding(.trailing, 15)
                    }.padding(.top, 30)
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(newsTopic, id: \.self) { item in
                                    Button(action: {
                                        selectedTab = item
                                        if item == "Популярное" {
                                            newsStore.fetchCategoryNews(category: "")
                                        } else if item == "Спорт" {
                                            newsStore.fetchCategoryNews(category: "&category=sports")
                                        } else if item == "Развлечение" {
                                            newsStore.fetchCategoryNews(category: "&category=entertainment")
                                        } else if item == "Технологии" {
                                            newsStore.fetchCategoryNews(category: "&category=technology")
                                        } else if item == "Здоровье" {
                                            newsStore.fetchCategoryNews(category: "&category=health")
                                        } else if item == "Бизнес" {
                                            newsStore.fetchCategoryNews(category: "&category=business")
                                        }
                                    }) {
                                        VStack {
                                            Text(item)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.secondary)
                                                .hoverEffect()
                                            Capsule()
                                                .fill(selectedTab == item ? Color.rgb(red: sessionStore.userData.rValue, green: sessionStore.userData.gValue, blue: sessionStore.userData.bValue) : Color.clear)
                                                .frame(height: 6)
                                        }.frame(width: 110)
                                    }
                                }
                            }.padding(.horizontal)
                        }
                        ForEach(newsStore.articles, id: \.self) { article in
                            Button(action: {
                                UIApplication.shared.open(URL(string: article.url!)!)
                            }) {
                                CardView(article: article)
                            }
                        }
                    }.frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
