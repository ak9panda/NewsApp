//
//  SearchNewsViewController.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/28/21.
//

import UIKit

class SearchNewsViewController: UIViewController {
    
    @IBOutlet weak var searchNewsTableView: UITableView!
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    private var searchNewsVM: SearchNewsViewModelProtocol?
    var didSelect: (ArticleVO) -> () = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        self.searchNewsVM?.articles.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.searchNewsTableView.reloadData()
            }
        })
    }
}

// MARK: - View Setup functions
extension SearchNewsViewController {
    func setupVM(vm: SearchNewsViewModelProtocol) {
        self.searchNewsVM = vm
    }
    
    func searchArticle(by keyword: String) {
        self.searchNewsVM?.fetchSearchNews(by: keyword)
    }
    
    func setupView() {
        searchBar.placeholder = "Search articles"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        searchNewsTableView.dataSource = self
        searchNewsTableView.delegate = self
        let ArticleCellNib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        searchNewsTableView.register(ArticleCellNib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        navigationItem.backButtonTitle = ""
    }
    
    func showEmptyMessage() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.searchNewsTableView.bounds.size.width, height: self.searchNewsTableView.bounds.size.height))
        messageLabel.text = "There is no match article found!"
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        self.searchNewsTableView.backgroundView = messageLabel
        self.searchNewsTableView.separatorStyle = .none
    }
    
    func restore() {
        self.searchNewsTableView.backgroundView = nil
        self.searchNewsTableView.separatorStyle = .singleLine
    }
}

// MARK: - Search bar Delegate
extension SearchNewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchArticle(by: text)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Search Table view Datasource
extension SearchNewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = searchNewsVM?.articles.value?.count ?? 0
        if rows > 0 {
            restore()
        }else {
            showEmptyMessage()
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell, let news = searchNewsVM?.articles.value else{
            return UITableViewCell()
        }
        let article = news[indexPath.row]
        let articleVO = Article.transformArticle(data: article, context: CoreDataStack.shared.viewContext)
        cell.setData(article: articleVO)
        return cell
    }

}

// MARK: - Search Table view Delegate
extension SearchNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let news = searchNewsVM?.articles.value else { return }
        let article = news[indexPath.row]
        let articleVO = Article.transformArticle(data: article, context: CoreDataStack.shared.viewContext)
        didSelect(articleVO)
    }
}
