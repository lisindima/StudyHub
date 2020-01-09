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
    
    private var currentDate = Date()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
        return dateFormatter
    }()
    
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
                        URLImage(URL(string:"\(session.urlImageProfile!)")!, incremental: false, expireAfter: Date(timeIntervalSinceNow: 31_556_926.0), placeholder: {
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
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    SelectNewsButton(nameButton: "Популярное", colorButton: Color.red, sizeButton: 120, action: {self.newsApi.fetchCategoryNews(category: "")})
                                        .padding(.trailing)
                                    SelectNewsButton(nameButton: "Спорт", colorButton: Color.orange, sizeButton: 120, action: {self.newsApi.fetchCategoryNews(category: "&category=sports")})
                                        .padding(.horizontal)
                                    SelectNewsButton(nameButton: "Развлечение", colorButton: Color.blue, sizeButton: 120, action: {self.newsApi.fetchCategoryNews(category: "&category=entertainment")})
                                        .padding(.horizontal)
                                    SelectNewsButton(nameButton: "Технологии", colorButton: Color.green, sizeButton: 120, action: {self.newsApi.fetchCategoryNews(category: "&category=technology")})
                                        .padding(.horizontal)
                                    SelectNewsButton(nameButton: "Здоровье", colorButton: Color.purple, sizeButton: 120, action: {self.newsApi.fetchCategoryNews(category: "&category=health")})
                                        .padding(.horizontal)
                                    SelectNewsButton(nameButton: "Бизнес", colorButton: Color.yellow, sizeButton: 120, action: {self.newsApi.fetchCategoryNews(category: "&category=business")})
                                        .padding(.leading)
                                        .padding(.trailing, 10)
                                }.padding()
                            }
                            ForEach(self.newsApi.articles, id: \.self) { item in
                                CardView(article: item)
                                    .onTapGesture {
                                        self.showDetailsNews = true
                                    }
                                    .sheet(isPresented: self.$showDetailsNews, onDismiss: {
                                    
                                    }, content: {
                                        DetailsNews(article: item)
                                    })
                                    .contextMenu {
                                        Button(action:
                                            {
                                                self.showNewsSafari(item)
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

struct SelectNewsButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var nameButton: String
    var colorButton: Color
    var sizeButton: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorButton)
                    .frame(width: sizeButton, height: sizeButton)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 3)
                            .frame(width: sizeButton, height: sizeButton)
                    )
                    .offset(x: 10, y: 10)
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .frame(width: sizeButton, height: sizeButton)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 3)
                            .frame(width: sizeButton, height: sizeButton)
                    )
                Text(nameButton)
                    .foregroundColor(colorButton)
                    .fontWeight(.semibold)
            }
        }
    }
}
