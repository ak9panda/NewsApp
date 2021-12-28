//
//  TopHeadlinesResponse.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation

// MARK: - TopHeadlines
struct ArticleList: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description : String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
