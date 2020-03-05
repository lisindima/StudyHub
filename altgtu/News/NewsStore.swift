//
//  NewsStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

class NewsStore: ObservableObject {
    
    @Published var articles: [Articles] = []
    
    static let shared = NewsStore()
    
    let apiUrl = "https://newsapi.org/v2/top-headlines?country=ru&apiKey="
    let apiKey = "762c4a68394f46f5b493923c11dc7e8b"
    
    func loadNews() {
        AF.request(apiUrl + apiKey)
        .validate()
        .responseDecodable(of: News.self) { response in
            guard let news = response.value else { return }
            self.articles = news.articles
        }
    }
    
    func fetchCategoryNews(category: String) {
        AF.request(apiUrl + apiKey + category)
        .validate()
        .responseDecodable(of: News.self) { response in
            guard let news = response.value else { return }
            self.articles = news.articles
        }
    }
}

struct Articles: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let source: Source?
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable, Hashable, Identifiable {
    let id: String?
    let name: String?
}

struct News: Codable, Hashable, Identifiable {
    var id: String?
    let status: String
    let totalResults: Int
    let articles: [Articles]
}
