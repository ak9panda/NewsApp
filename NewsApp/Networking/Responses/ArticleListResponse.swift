//
//  TopHeadlinesResponse.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation
import CoreData

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
    
    static func saveArticleEntity(data: Article, context: NSManagedObjectContext) {
        let uuid = UUID()
        let articleEntity = ArticleVO(context: context)
        articleEntity.id = uuid.uuidString
        articleEntity.source_id = data.source?.id ?? ""
        articleEntity.source_name = data.source?.name ?? ""
        articleEntity.author = data.author ?? ""
        articleEntity.title = data.title ?? ""
        articleEntity.article_description = data.description ?? ""
        articleEntity.url = data.url ?? ""
        articleEntity.urlToImage = data.urlToImage ?? ""
        articleEntity.publishedAt = data.publishedAt ?? ""
        articleEntity.content = data.content ?? ""
        
        context.performAndWait {
            do{
                try context.save()
            }catch {
                print("failed to save articles : \(error.localizedDescription)")
            }
        }
    }
    
    static func transformArticle(data: Article, context: NSManagedObjectContext) -> ArticleVO {
        let uuid = UUID()
        let articleEntity = ArticleVO(context: context)
        articleEntity.id = uuid.uuidString
        articleEntity.source_id = data.source?.id ?? ""
        articleEntity.source_name = data.source?.name ?? ""
        articleEntity.author = data.author ?? ""
        articleEntity.title = data.title ?? ""
        articleEntity.article_description = data.description ?? ""
        articleEntity.url = data.url ?? ""
        articleEntity.urlToImage = data.urlToImage ?? ""
        articleEntity.publishedAt = data.publishedAt ?? ""
        articleEntity.content = data.content ?? ""
        
        return articleEntity
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
