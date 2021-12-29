//
//  Endpoint.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/29/21.
//

import Foundation

struct Endpoint {
    static let baseURL = "https://newsapi.org/v2/"
    static let APIKey = "d043ec92bac0478f88e861eb3ff94437"
}

struct Routes {
    static let TOP_HEADLINE = "\(Endpoint.baseURL)top-headlines?country=us&apiKey=\(Endpoint.APIKey)"
}
