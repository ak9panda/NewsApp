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
    let discoverNavigationController: UINavigationController
    let bookmarkNavigationController: UINavigationController
    
    init(window: UIWindow) {
        
        // set navigbation controllers
        discoverNavigationController = UINavigationController()
        bookmarkNavigationController = UINavigationController()
        
        let discover = self.storyboard.instantiateViewController(withIdentifier: "DiscoverNewsViewController") as! DiscoverNewsViewController
        discover.didSelect = didSelectArticle(article:)
        discover.didTouchSearch = didTouchSearchBtn
        discoverNavigationController.viewControllers = [discover]
        
        let bookmark = self.storyboard.instantiateViewController(withIdentifier: "BookmarkNewsViewController") as! BookmarkNewsViewController
        bookmark.didSelect = didSelectArticleFromBookmark(article:)
        bookmarkNavigationController.viewControllers = [bookmark]
        
        let tabBarController = UITabBarController()
        tabBarController.hidesBottomBarWhenPushed = true
        tabBarController.setViewControllers([
            discoverNavigationController,
            bookmarkNavigationController
        ],animated: true)
        
        tabBarController.tabBar.barTintColor = .systemBackground
        tabBarController.tabBar.tintColor = .label
        tabBarController.tabBar.items![0].title = "Discover"
        tabBarController.tabBar.items![0].image = UIImage.init(named: "news_empty")
        tabBarController.tabBar.items![0].selectedImage = UIImage.init(named: "news_fill")
        tabBarController.tabBar.items![1].title = "Bookmark"
        tabBarController.tabBar.items![1].image = UIImage.init(named: "star_empty")
        tabBarController.tabBar.items![1].selectedImage = UIImage.init(named: "star_empty")
        window.rootViewController = tabBarController
    }
    
    private func didSelectArticle(article: ArticleVO) {
        let detailVC = self.storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailVC.didTapNewsPage = didTapNewsPageButton(webURL:)
        detailVC.setupData(article: article)
        detailVC.hidesBottomBarWhenPushed = true
        self.discoverNavigationController.pushViewController(detailVC, animated: true)
    }
    
    private func didSelectArticleFromBookmark(article: ArticleVO) {
        let detailVC = self.storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        detailVC.didTapNewsPage = didTapNewsPageButtonfromBookmark(webURL:)
        detailVC.setupData(article: article)
        detailVC.hidesBottomBarWhenPushed = true
        self.bookmarkNavigationController.pushViewController(detailVC, animated: true)
    }
    
    private func didTouchSearchBtn() {
        let searchVC = self.storyboard.instantiateViewController(withIdentifier: "SearchNewsViewController") as! SearchNewsViewController
        searchVC.didSelect = didSelectArticle(article:)
        searchVC.setupVM(vm: SearchNewsViewModel())
        searchVC.hidesBottomBarWhenPushed = true
        self.discoverNavigationController.pushViewController(searchVC, animated: true)
    }
    
    private func didTapNewsPageButton(webURL: String) {
        let newsWebVC = self.storyboard.instantiateViewController(withIdentifier: "NewsWebViewViewController") as! NewsWebViewViewController
        newsWebVC.setupNewsPage(with: webURL)
        self.discoverNavigationController.pushViewController(newsWebVC, animated: true)
    }
    
    private func didTapNewsPageButtonfromBookmark(webURL: String) {
        let newsWebVC = self.storyboard.instantiateViewController(withIdentifier: "NewsWebViewViewController") as! NewsWebViewViewController
        newsWebVC.setupNewsPage(with: webURL)
        self.bookmarkNavigationController.pushViewController(newsWebVC, animated: true)
    }
}
