//
//  ModelNews.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

struct Articles: Codable, Hashable, Identifiable {
    let id: UUID?
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
    var id: UUID?
    let status: String
    let totalResults: Int
    let articles: [Articles]
}



