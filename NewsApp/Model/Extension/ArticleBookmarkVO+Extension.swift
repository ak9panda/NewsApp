//
//  ArticleBookmarkVO+Extension.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation
import CoreData

extension ArticleBookmarkVO {
    
    static func save(articleId: String, context: NSManagedObjectContext) -> Bool {
        let entity = ArticleBookmarkVO(context: context)
        entity.id = articleId
        do {
            try context.save()
            return true
        }catch {
            print("failed to save bookmark article")
            return false
        }
    }
    
    static func remove(articleId: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequset: NSFetchRequest<ArticleBookmarkVO> = ArticleBookmarkVO.fetchRequest()
        fetchRequset.predicate = NSPredicate(format: "id == %@", articleId)
        do {
            let data = try context.fetch(fetchRequset)
            if !data.isEmpty {
                data.forEach { article in
                    context.delete(article)
                }
                try? context.save()
                return true
            }
            return false
        }catch {
            print("failed to remove bookmark article")
            return false
        }
    }
    
    static func fetch() -> [ArticleVO]? {
        let fetchRequest: NSFetchRequest<ArticleBookmarkVO> = ArticleBookmarkVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return [ArticleVO]()
            }
            var bookmarkarticles = [ArticleVO]()
            data.forEach { article in
                let articleId = article.id
                bookmarkarticles.append(ArticleVO.getArticleById(articleId: articleId!)!)
            }
            return bookmarkarticles
        }catch {
            print("GetBookmarkarticles : \(error.localizedDescription)")
            return [ArticleVO]()
        }
    }
    
    static func isBookmarked(articleId: String) -> Bool {
        let fetchRequest: NSFetchRequest<ArticleBookmarkVO> = ArticleBookmarkVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", articleId)
        fetchRequest.predicate = predicate
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            return data.count > 0
        }catch {
            print("isBookmarked: \(error.localizedDescription)")
            return false
        }
    }
}
