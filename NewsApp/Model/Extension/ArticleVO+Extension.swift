//
//  ArticleVO+Extension.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation
import CoreData

extension ArticleVO {
    
    static func fetchArticles() -> [ArticleVO]? {
        let fetchRequest: NSFetchRequest<ArticleVO> = ArticleVO.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let data = try? CoreDataStack.shared.viewContext.fetch(fetchRequest) {
            return data
        }
        
        return nil
    }
    
    static func deleteAllArticles() {
        let fetchRequest: NSFetchRequest<ArticleVO> = ArticleVO.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let data = try? CoreDataStack.shared.viewContext.fetch(fetchRequest), !data.isEmpty {
            data.forEach { movie in
                CoreDataStack.shared.viewContext.delete(movie)
            }
            try? CoreDataStack.shared.viewContext.save()
        }
    }
    
    static func getArticleById(articleId: String) -> ArticleVO? {
        let fetchRequest: NSFetchRequest<ArticleVO> = ArticleVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", articleId)
        fetchRequest.predicate = predicate
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data[0]
        }catch {
            print("failed to fetch movie with id \(articleId): \(error.localizedDescription)")
            return nil
        }
    }
}
