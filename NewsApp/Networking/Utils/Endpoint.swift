//
//  Endpoint.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/29/21.
//

import Foundation

struct Endpoint {
    static let baseURL = "https://newsapi.org/v2/"
    static let APIKey = "ebde7ed148734db899e388df2f0aa9e2"
}

struct Routes {
    static let TOP_HEADLINE = "\(Endpoint.baseURL)top-headlines?country=us&apiKey=\(Endpoint.APIKey)"
}
