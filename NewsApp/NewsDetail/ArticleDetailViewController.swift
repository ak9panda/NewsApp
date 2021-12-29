//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import UIKit
import SDWebImage

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnGotonewspage: UIButton!
    
    private var article: ArticleVO?
    private var articleId: String = ""
    var didTapNewsPage: (_ webURL: String) -> () = { _ in }
    private var bookmarkStatus = false
    private var bookmarkBtn = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    @IBAction func onTouchToNewsPage(_ sender: Any) {
        if let webURL = article?.url {
            didTapNewsPage(webURL)
        }
    }
}

extension ArticleDetailViewController {
    func setupData(article: ArticleVO) {
        self.article = article
    }
    
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        bookmarkBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onTouchBookmarkBtn(_:)))
        if let data = article {
            self.navigationItem.title = data.source_name
            lblTitle.text = data.title
            lblDate.text = Date.string(iso: data.publishedAt ?? "")
            lblAuthor.text = data.author
            let fullContent = "\(data.article_description ?? "") \n \(data.content ?? "")"
            lblContent.text = fullContent
            if let imgUrl = data.urlToImage {
                imgCover.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            }
            articleId = data.id ?? ""
            bookmarkStatus = ArticleBookmarkVO.isBookmarked(articleId: articleId)
        }
        imgCover.layer.masksToBounds = true
        imgCover.layer.cornerRadius = 5
        btnGotonewspage.layer.cornerRadius = 10
        bookmarkBtn.image = bookmarkStatus ? UIImage.init(named: "bookmark_fill") : UIImage.init(named: "bookmark_empty")
        self.navigationItem.rightBarButtonItem = bookmarkBtn
    }
    
    @objc func onTouchBookmarkBtn(_ sender: UIButton) {
        if articleId != "" {
            if bookmarkStatus {
                bookmarkStatus = !(ArticleBookmarkVO.remove(articleId: articleId, context: CoreDataStack.shared.viewContext))
            }else {
                bookmarkStatus = ArticleBookmarkVO.save(articleId: articleId, context: CoreDataStack.shared.viewContext)
            }
            bookmarkBtn.image = bookmarkStatus ? UIImage(named: "bookmark_fill") : UIImage(named: "bookmark_empty")
        }
    }
}
