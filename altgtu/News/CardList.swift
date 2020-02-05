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
    @EnvironmentObject var sessionStore: SessionStore
    
    @State private var showDetailsNews: Bool = false
    
    private let stringDate: String = {
        var currentDate: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
        let createStringDate = dateFormatter.string(from: currentDate)
        return createStringDate
    }()
    
    var body: some View {
        Group {
            if newsStore.articles.isEmpty {
                NavigationView {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                ActivityIndicator(styleSpinner: .large)
                                    .onAppear(perform: newsStore.loadNews)
                            }
                            Spacer()
                        }
                    }.frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                }.navigationViewStyle(StackNavigationViewStyle())
            } else {
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(stringDate)".uppercased())
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
                                .placeholder {
                                    ActivityIndicator(styleSpinner: .medium)
                                }
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 45, height: 45)
                                .padding(.trailing, 15)
                        }.padding(.top, 30)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                SelectNewsButton(nameButton: "Популярное", colorButton: Color.red, sizeButton: 120, action: {self.newsStore.fetchCategoryNews(category: "")})
                                    .padding(.trailing)
                                SelectNewsButton(nameButton: "Спорт", colorButton: Color.orange, sizeButton: 120, action: {self.newsStore.fetchCategoryNews(category: "&category=sports")})
                                    .padding(.horizontal)
                                SelectNewsButton(nameButton: "Развлечение", colorButton: Color.blue, sizeButton: 120, action: {self.newsStore.fetchCategoryNews(category: "&category=entertainment")})
                                    .padding(.horizontal)
                                SelectNewsButton(nameButton: "Технологии", colorButton: Color.green, sizeButton: 120, action: {self.newsStore.fetchCategoryNews(category: "&category=technology")})
                                    .padding(.horizontal)
                                SelectNewsButton(nameButton: "Здоровье", colorButton: Color.purple, sizeButton: 120, action: {self.newsStore.fetchCategoryNews(category: "&category=health")})
                                    .padding(.horizontal)
                                SelectNewsButton(nameButton: "Бизнес", colorButton: Color.yellow, sizeButton: 120, action: {self.newsStore.fetchCategoryNews(category: "&category=business")})
                                    .padding(.leading)
                                    .padding(.trailing, 10)
                            }.padding()
                        }
                        ForEach(self.newsStore.articles, id: \.self) { item in
                            NavigationLink(destination: DetailsNews(article: item)) {
                                CardView(article: item)
                            }
                        }
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .frame(minWidth: nil, idealWidth: 600, maxWidth: 700, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
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
