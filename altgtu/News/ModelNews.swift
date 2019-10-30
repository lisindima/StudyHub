//
//  ModelNews.swift
//  altgtu
//
//  Created by Дмитрий Лисин on 19.10.2019.
//  Copyright © 2019 Dmitriy Lisin. All rights reserved.
//

import Foundation

public typealias Articles = [Article]

public struct ModelNews: Codable, Hashable {
    public let status: String?
    public let totalResults: Int?
    public let articles: [Article]?

    public init(status: String?, totalResults: Int?, articles: [Article]?) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

public struct Article: Codable, Hashable {
    public let source: Source?
    public let author: String?
    public let title: String?
    public let articleDescription: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription
        case url, urlToImage, publishedAt, content
    }

    public init(source: Source?, author: String?, title: String?, articleDescription: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

public struct Source: Codable, Hashable {
    public let id: String?
    public let name: String?

    public init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
}



