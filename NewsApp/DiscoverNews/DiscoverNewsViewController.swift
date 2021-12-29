//
//  DiscoverNewsViewController.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import UIKit

class DiscoverNewsViewController: UIViewController {
    
    @IBOutlet weak var DiscoverNewTableView: UITableView!
    
    private var newsVM: DiscoverNewsViewModelProtocol?
    var didSelect: (ArticleVO) -> () = { _ in }
    var didTouchSearch: () -> () = {}
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = .green
        return refreshControl
    }()

    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func onTouchSearchBtn(_ sender: Any) {
        didTouchSearch()
    }
}

// MARK: - View Controller Setup
extension DiscoverNewsViewController {
    private func setupViewModel(vm: DiscoverNewsViewModelProtocol = DiscoverNewsViewModel()) {
        self.newsVM = vm
        self.newsVM?.fetchTopHeadline()
        self.newsVM?.error.bind({ [weak self] error in
            DispatchQueue.main.async {
                if error != APIError.initial {
                    self?.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                }
            }
        })
        self.newsVM?.articles.bind({ [weak self] _ in
            DispatchQueue.main.async {
                print("news count: \(self?.newsVM?.articles.value?.count ?? 0)")
                self?.DiscoverNewTableView.reloadData()
            }
        })
        
    }
    
    private func setupView() {
        DiscoverNewTableView.dataSource = self
        DiscoverNewTableView.delegate = self
        let ArticleCellNib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        DiscoverNewTableView.register(ArticleCellNib, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        navigationItem.backButtonTitle = ""
        self.DiscoverNewTableView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        newsVM?.refreshTopHeadline()
    }
}

// MARK: - TableView Datasource
extension DiscoverNewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = newsVM?.articles.value?.count else { return 0 }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell, let news = newsVM?.articles.value else{
            return UITableViewCell()
        }
        cell.setData(article: news[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension DiscoverNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let news = newsVM?.articles.value else { return }
        didSelect(news[indexPath.row])
    }
}
