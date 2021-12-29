//
//  DiscoverNewsViewModel.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation

protocol DiscoverNewsViewModelProtocol {
    var articles: Observable<[ArticleVO]> { get }
    var error: Observable<APIError> { get }
    
    func fetchTopHeadline()
    func refreshTopHeadline()
}

struct DiscoverNewsViewModel: DiscoverNewsViewModelProtocol {
    
    var articles = Observable<[ArticleVO]>([])
    var error = Observable<APIError>(.initial)
    private let service: NewsNetworkClientProtocol?
    
    init(service: NewsNetworkClientProtocol = NewsNetworkClient()) {
        self.service = service
    }
    
    func fetchTopHeadline(){
        
        if let articles = ArticleVO.fetchArticles() {
            if articles.isEmpty {
                self.service?.fetchTopHeadlines(Completion: { result in
                    switch result {
                    case .success(let topHeadline):
                        topHeadline.articles.forEach { article in
                            Article.saveArticleEntity(data: article, context: CoreDataStack.shared.viewContext)
                        }
                        let articleVOs = ArticleVO.fetchArticles()
                        self.articles.value = articleVOs
                    case .failure(let error):
                        self.error.value = error
                        print("error: \(error.localizedDescription)")
                    }
                })
            }else {
                self.articles.value = articles
            }
        }else {
            self.error.value = APIError.noData
        }
    }
    
    func refreshTopHeadline() {
        // delete all news
        ArticleVO.deleteAllArticles()
        // fetch article again
        fetchTopHeadline()
    }

}
