//
//  DownloadViewController.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
   private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray2
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        return button
    }()
    
    private let pageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Page 1"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return indicator
    }()
    
    var search = Search(count: 0, next: nil, previous: nil, results: nil) {
        didSet {
            pageCountLabel.text = "Страница " + getNumberOfPage(string: search.next)
            title = "Найденно \(String(search.count)) книг"
            tableView.reloadData()
        }
    }
    
    var delegate: LibraryViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(pageCountLabel)

        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.backgroundColor = .systemBackground
        
        tableView.rowHeight = 80
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstrains()
    }
    
    private func downloadData() {
        
        NetworkManage.shared.fetchDataSearch(
            url: LinK.searchBooks.rawValue,
            progressDownload: { progressDownload in
//                self.progressView.setProgress(Float(progressDownload.fractionCompleted),
//                                              animated: true)
            },
            completion: { search in
                self.search = search
                self.activityIndicator.stopAnimating()
            }
        )
        
    }
    
    @objc private func backButtonAction() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        if search.previous != nil {
            NetworkManage.shared.fetchDataSearch(
                url: search.previous ?? "",
                progressDownload: { _ in  },
                completion: { search in
                    self.search = search
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            )
            
        }
    }
    
    @objc private func nextButtonAction() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        if search.next != nil {
            NetworkManage.shared.fetchDataSearch(
                url: search.next ?? "",
                progressDownload: { _ in},
                completion: {
                    search in self.search = search
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            )
            
        }
    }
    
    private func getNumberOfPage(string: String?) -> String {
        let string = string?.components(separatedBy: "http://gutendex.com/books/?mime_type=text%2F&page=").last ?? ""
        let page = (Int(string) ?? 0) - 1
        return String(page)
    }
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            pageCountLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height ?? 0)),
            pageCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: pageCountLabel.bottomAnchor),
            backButton.trailingAnchor.constraint(equalTo: pageCountLabel.leadingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: pageCountLabel.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: pageCountLabel.trailingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20)
        ])
        
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        search.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = search.results?[indexPath.row].title
        content.secondaryText = search.results?[indexPath.row].authors?.first?.name
        
        if let url = search.results?[indexPath.row].formats.imageJPEG {
            NetworkManage.shared.fetchDataFrom(url: url) { progress in
                
            } completion: { data in
                content.image = UIImage(data: data)
                cell.contentConfiguration = content
            }
        }
        content.image = UIImage(named: "book")
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.delegateLibrary = delegate
        detailVC.result = search.results?[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
