//
//  NewsStore.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import SwiftUI

class NewsStore: ObservableObject {
    
    @Published var news: News?
    @Published var articles: [Articles] = []
    
    let apiUrl = "https://newsapi.org/v2/top-headlines?country=ru&apiKey="
    let apiKey = "762c4a68394f46f5b493923c11dc7e8b"
    
    func loadNews() {
        guard let url = URL(string: apiUrl + apiKey) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        self.news = try JSONDecoder().decode(News.self, from: data)
                        self.articles = self.news!.articles
                    } catch let err {
                        print("Error :\(err)")
                    }
                }
            } else {
                print("News: \(response.statusCode)")
            }
        }.resume()
    }
    
    func fetchCategoryNews(category: String) {
        guard let url = URL(string: apiUrl + apiKey + category) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        self.news = try JSONDecoder().decode(News.self, from: data)
                        self.articles = self.news!.articles
                    } catch let err {
                        print("Error :\(err)")
                    }
                }
            } else {
                print("CategoryNews: \(response.statusCode)")
            }
        }.resume()
    }
}