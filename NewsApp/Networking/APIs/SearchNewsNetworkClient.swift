//
//  SearchNewsNetworkClient.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation

protocol SearchNewsNetworkClientProtocol: ApiClient {
    func fetchSearchNews(name: String, Completion: @escaping(Result<ArticleList, APIError>)-> Void)
}

struct SearchNewsNetworkClient: SearchNewsNetworkClientProtocol {
    func fetchSearchNews(name: String, Completion: @escaping (Result<ArticleList, APIError>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let curDateString = formatter.string(from: Date())
        formatter.dateFormat = "yyyy-mm-dd"
        let route = URL(string: "\(Endpoint.baseURL)everything?q=\(name)&from=\(curDateString)&sortBy=popularity&apiKey=\(Endpoint.APIKey)")!
        URLSession.shared.dataTask(with: route) { data, response, error in
            guard let result: (Result<ArticleList, APIError>) = self.responseHandler(data: data, urlResponse: response, error: error) else { return }
            Completion(result)
        }.resume()
    }
}
