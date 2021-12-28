//
//  DiscoverNewsViewModel.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation

protocol DiscoverNewsViewModelProtocol {
    var articles: Observable<[Article]> { get }
    var error: Observable<APIError> { get }
    
    func fetchTopHeadline()
}

struct DiscoverNewsViewModel: DiscoverNewsViewModelProtocol {
    
    var articles = Observable<[Article]>([])
    var error = Observable<APIError>(.initial)
    private let service: NewsNetworkClientProtocol?
    
    init(service: NewsNetworkClientProtocol = NewsNetworkClient()) {
        self.service = service
    }
    
    func fetchTopHeadline(){
        self.service?.fetchTopHeadlines(Completion: { result in
            switch result {
            case .success(let topHeadline):
                self.articles.value = topHeadline.articles
            case .failure(let error):
                self.error.value = error
                print("error: \(error.localizedDescription)")
            }
        })
    }
}
