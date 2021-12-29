//
//  BookmarkNewsViewModel.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/29/21.
//

import Foundation

protocol BookmarkNewsViewModelProtocol {
    var articles: Observable<[ArticleVO]> { get }
    var error: Observable<APIError> { get }
    
    func fetchBookmark()
}

struct BookmarkNewsViewModel: BookmarkNewsViewModelProtocol {
    
    var articles = Observable<[ArticleVO]>([])
    var error = Observable<APIError>(.initial)
    
    func fetchBookmark() {
        guard let bookmarks = ArticleBookmarkVO.fetch() else {
            error.value = APIError.noData
            return
        }
        if bookmarks.count > 0 {
            articles.value = bookmarks
        }else {
            error.value = APIError.noData
        }
    }
}
