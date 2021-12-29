//
//  NewsNetworkClient.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation

protocol NewsNetworkClientProtocol: ApiClient {
    func fetchTopHeadlines(Completion: @escaping(Result<ArticleList, APIError>)-> Void)
}

struct NewsNetworkClient: NewsNetworkClientProtocol {
    
    func fetchTopHeadlines(Completion: @escaping (Result<ArticleList, APIError>) -> Void) {
        let route = URL(string: Routes.TOP_HEADLINE)!
        URLSession.shared.dataTask(with: route) { data, response, error in
            guard let result: (Result<ArticleList, APIError>) = self.responseHandler(data: data, urlResponse: response, error: error) else { return }
            Completion(result)
        }.resume()
    }
}
