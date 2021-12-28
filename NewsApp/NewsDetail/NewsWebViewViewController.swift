//
//  NewsWebViewViewController.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import UIKit
import WebKit

class NewsWebViewViewController: UIViewController {
    
    var newsURL: String = ""
    let newsWebView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(newsWebView)
        
        guard let pageUrl = URL(string: newsURL) else { return }
        newsWebView.load(URLRequest(url: pageUrl))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsWebView.frame = view.bounds
    }
}

extension NewsWebViewViewController {
    func setupNewsPage(with url: String) {
        self.newsURL = url
    }
}
