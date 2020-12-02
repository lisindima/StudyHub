//
//  NewsStore.swift
//  StudyHub
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Alamofire
import Combine
import SwiftUI

class NewsStore: ObservableObject {
    @Published var articles = [Articles]()
    @Published var newsLoadingFailure: Bool = false

    static let shared = NewsStore()

    let apiUrl = "https://newsapi.org/v2/top-headlines?country=ru&apiKey="
    let apiKey = "762c4a68394f46f5b493923c11dc7e8b"

    func loadNews() {
        AF.request(apiUrl + apiKey)
            .validate()
            .responseDecodable(of: News.self) { [self] response in
                switch response.result {
                case .success:
                    guard let news = response.value else { return }
                    articles = news.articles
                case let .failure(error):
                    newsLoadingFailure = true
                    print("Список новостей не загружен: \(error)")
                }
            }
    }

    func fetchCategoryNews(category: String) {
        AF.request(apiUrl + apiKey + category)
            .validate()
            .responseDecodable(of: News.self) { [self] response in
                switch response.result {
                case .success:
                    guard let news = response.value else { return }
                    articles = news.articles
                case let .failure(error):
                    newsLoadingFailure = true
                    print("Список новостей не загружен: \(error)")
                }
            }
    }
}

struct Articles: Codable, Hashable {
    var source: Source?
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct Source: Codable, Hashable {
    var name: String?
}

struct News: Codable, Hashable {
    var status: String
    var totalResults: Int
    var articles: [Articles]
}
