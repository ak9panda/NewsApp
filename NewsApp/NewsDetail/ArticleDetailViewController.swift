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
    
    private var article: Article?
    var didTapNewsPage: (_ webURL: String) -> () = { _ in }

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
    func setupData(article: Article) {
        self.article = article
    }
    
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if let data = article {
            self.navigationItem.title = data.source?.name
            lblTitle.text = data.title
            lblDate.text = Date.string(iso: data.publishedAt ?? "")
            lblAuthor.text = data.author
            let fullContent = "\(data.description ?? "") \n \(data.content ?? "")"
            lblContent.text = fullContent
            if let imgUrl = data.urlToImage {
                imgCover.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
            }
        }
        imgCover.layer.masksToBounds = true
        imgCover.layer.cornerRadius = 5
        btnGotonewspage.layer.cornerRadius = 10
    }
}
