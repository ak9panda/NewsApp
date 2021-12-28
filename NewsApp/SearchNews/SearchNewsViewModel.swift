//
//  SearchNewsViewModel.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation

protocol SearchNewsViewModelProtocol {
    var articles: Observable<[Article]> { get }
    
    func fetchSearchNews(by keyword: String)
}

struct SearchNewsViewModel: SearchNewsViewModelProtocol {
    
    var articles = Observable<[Article]>([])
    private let service: SearchNewsNetworkClientProtocol?
    
    init(service: SearchNewsNetworkClientProtocol = SearchNewsNetworkClient()) {
        self.service = service
    }
    
    func fetchSearchNews(by keyword: String){
        self.service?.fetchSearchNews(name: keyword, Completion: { result in
            switch result {
            case .success(let topHeadline):
                self.articles.value = topHeadline.articles
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
