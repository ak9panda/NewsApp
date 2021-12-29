//
//  BookmarkNewsViewController.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/29/21.
//

import UIKit

class BookmarkNewsViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    private var bookmarkVM: BookmarkNewsViewModelProtocol?
    private var articles = [ArticleVO]()
    var didSelect: (ArticleVO) -> () = { _ in }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = .green
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewModel()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.bookmarkVM?.fetchBookmark()
        self.bookmarkTableView.reloadData()
    }
}

// MARK: - ViewController Setup
extension BookmarkNewsViewController {
    func setupViewModel(vm: BookmarkNewsViewModelProtocol? = BookmarkNewsViewModel()) {
        self.bookmarkVM = vm
        self.bookmarkVM?.error.bind({ [weak self] error in
            DispatchQueue.main.async {
                if error != APIError.initial {
                    self?.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                    self?.articles = []
                    self?.bookmarkTableView.reloadData()
                }
            }
        })
        self.bookmarkVM?.articles.bind({ [weak self] articles in
            DispatchQueue.main.async {
                print("news count: \(self?.bookmarkVM?.articles.value?.count ?? 0)")
                if let data = articles {
                    self?.articles = data
                    self?.bookmarkTableView.reloadData()
                }
            }
        })
    }
    
    func setupView() {
        navigationItem.title = "Bookmark News"
        navigationItem.backButtonTitle = ""
        bookmarkTableView.dataSource = self
        bookmarkTableView.delegate = self
        bookmarkTableView.refreshControl = refreshControl
        let ArticleCellNib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        bookmarkTableView.register(ArticleCellNib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        self.bookmarkTableView.reloadData()
    }
    
    func showEmptyMessage() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bookmarkTableView.bounds.size.width, height: self.bookmarkTableView.bounds.size.height))
        messageLabel.text = "There is no bookmark articles!"
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        self.bookmarkTableView.backgroundView = messageLabel
        self.bookmarkTableView.separatorStyle = .none
    }
    
    func restore() {
        self.bookmarkTableView.backgroundView = nil
        self.bookmarkTableView.separatorStyle = .singleLine
    }
}

// MARK: - TableView Datasource
extension BookmarkNewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = articles.count
        if rows > 0 {
            restore()
        }else {
            showEmptyMessage()
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else{
            return UITableViewCell()
        }
        cell.setData(article: articles[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension BookmarkNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelect(articles[indexPath.row])
    }
}
