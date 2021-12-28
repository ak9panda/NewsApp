//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSourceName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    private var article: Article? {
        didSet {
            if let article = article {
                lblSourceName.text = article.source?.name
                lblTitle.text = article.title
                if let img = article.urlToImage {
                    imgCover.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.progressiveLoad, completed: nil)
                }
                lblDate.text = Date.string(iso: article.publishedAt ?? "")
            }
        }
    }
    
    func setData(article: Article) {
        self.article = article
    }
    
    static var identifier : String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgCover.layer.masksToBounds = true
        imgCover.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
