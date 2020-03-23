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
    @Published var newsLoadingFailure: Bool = false
    
    static let shared = NewsStore()
    
    let apiUrl = "https://newsapi.org/v2/top-headlines?country=ru&apiKey="
    let apiKey = "762c4a68394f46f5b493923c11dc7e8b"
    
    func loadNews() {
        AF.request(apiUrl + apiKey)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: News.self) { response in
                switch response.result {
                case .success( _):
                    guard let news = response.value else { return }
                    self.articles = news.articles
                case .failure(let error):
                    self.newsLoadingFailure = true
                    print("Список новостей не загружен: \(error.errorDescription!)")
                }
        }
    }
    
    func fetchCategoryNews(category: String) {
        AF.request(apiUrl + apiKey + category)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: News.self) { response in
                switch response.result {
                case .success( _):
                    guard let news = response.value else { return }
                    self.articles = news.articles
                case .failure(let error):
                    self.newsLoadingFailure = true
                    print("Список новостей не загружен: \(error.errorDescription!)")
                }
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
