//
//  NewsAPI.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Combine
import SwiftUI

class NewsAPI: ObservableObject {
    
    @Published var articles: Articles = [Article]()
    
    init() {
        guard let url: URL = URL(string: "https://newsapi.org/v2/top-headlines?country=ru&apiKey=376a97643c6c4633afe57427b71e8ebd") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = data else { return }
                let welcome = try JSONDecoder().decode(ModelNews.self, from: json)
                DispatchQueue.main.async {
                    self.articles = welcome.articles!
                }
            }
            catch {
                print(error)
            }
        }
        .resume()
    }
}
