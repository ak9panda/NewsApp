//
//  AppNevigation.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import Foundation
import UIKit

class AppNevigation {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        navigationController = window.rootViewController as! UINavigationController
        let discoverNews = navigationController.viewControllers[0] as! DiscoverNewsViewController
        discoverNews.didSelect = didSelectArticle(article:)
        discoverNews.didTouchSearch = didTouchSearchBtn
    }
    
    private func didSelectArticle(article: Article) {
        let detailVC = self.storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailVC.didTapNewsPage = didTapNewsPageButton(webURL:)
        detailVC.setupData(article: article)
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    private func didTouchSearchBtn() {
        let searchVC = self.storyboard.instantiateViewController(withIdentifier: "SearchNewsViewController") as! SearchNewsViewController
        searchVC.didSelect = didSelectArticle(article:)
        searchVC.setupVM(vm: SearchNewsViewModel())
        self.navigationController.pushViewController(searchVC, animated: true)
    }
    
    private func didTapNewsPageButton(webURL: String) {
        let newsWebVC = self.storyboard.instantiateViewController(withIdentifier: "NewsWebViewViewController") as! NewsWebViewViewController
        newsWebVC.setupNewsPage(with: webURL)
        self.navigationController.pushViewController(newsWebVC, animated: true)
    }
}
