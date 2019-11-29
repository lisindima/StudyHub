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
    
    @ObservedObject var newsVM = NewsViewModel()
    @EnvironmentObject var session: SessionStore
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    var currentDate = Date()
    
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
                    ScrollView(showsIndicators: false) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(currentDate, formatter: dateFormatter)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text("Сегодня")
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                                    .foregroundColor(.primary)
                            }
                            .padding(.leading, 15)
                            Spacer()
                            URLImage(URL(string:"\(session.url ?? "")")!, incremental : false, expireAfter : Date ( timeIntervalSinceNow : 31_556_926.0 ), placeholder: {
                                ProgressView($0) { progress in
                                    ZStack {
                                        if progress > 0.0 {
                                            CircleProgressView(progress).stroke(lineWidth: 8.0)
                                                .frame(width: 35, height: 35)
                                        }
                                        else {
                                            CircleActivityView().stroke(lineWidth: 50.0)
                                                .frame(width: 35, height: 35)
                                        }
                                    }
                                }.frame(width: 45, height: 45)
                            }) { proxy in
                                    proxy.image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                        .frame(width: 45, height: 45)
                                        .padding(.trailing, 15)
                            }
                        }.padding(.top, 30)
                        VStack(alignment: .center) {
                            ScrollView(.horizontal, showsIndicators: false){
                               VStack (alignment: .leading){
                                   HStack{
                                        Button(action: {self.newsVM.fetchCategoryNews(category: "")}, label: {Text("Популярное")})
                                            .frame(width: 120, height: 110)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Divider()
                                            .frame(height: 90)
                                            .padding()
                                        Button(action: {self.newsVM.fetchCategoryNews(category: "&category=sports")}, label: {Text("Спорт")})
                                            .frame(width: 120, height: 110)
                                            .background(Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Button(action: {self.newsVM.fetchCategoryNews(category: "&category=entertainment")}, label: {Text("Развлечение")})
                                            .frame(width: 120, height: 110)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Button(action: {self.newsVM.fetchCategoryNews(category: "&category=technology")}, label: {Text("Технологии")})
                                            .frame(width: 120, height: 110)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Button(action: {self.newsVM.fetchCategoryNews(category: "&category=health")}, label: {Text("Здоровье")})
                                            .frame(width: 120, height: 110)
                                            .background(Color.purple)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Button(action: {self.newsVM.fetchCategoryNews(category: "&category=business")}, label: {Text("Бизнес")})
                                            .frame(width: 120, height: 110)
                                            .background(Color.yellow)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
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
            }
        }
    }
}
