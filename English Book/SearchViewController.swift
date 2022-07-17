//
//  DownloadViewController.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        return button
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "Число - nill"
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let nextLabel: UILabel = {
        let label = UILabel()
        label.text = "Слудущая страница"
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return indicator
    }()
    
    var search = Search(count: 0, next: nil, previous: nil, results: nil) {
        didSet {
            nextLabel.text = "Страница №" + getNumberOfPage(string: search.next)
            countLabel.text = String(search.count)
            tableView.reloadData()
        }
    }
    var results: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(nextLabel)
        view.addSubview(countLabel)
        

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.backgroundColor = .white
        
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
        activityIndicator.startAnimating()
        if search.previous != nil {
            NetworkManage.shared.fetchDataSearch(
                url: search.previous ?? "",
                progressDownload: { progressDownload in
//                    self.progressView.setProgress(Float(progressDownload.fractionCompleted),
//                                                  animated: true)
                },
                completion: { search in
                    self.search = search
                    self.activityIndicator.stopAnimating()
                }
            )
            
        }
    }
    
    @objc private func nextButtonAction() {
        activityIndicator.startAnimating()
        if search.next != nil {
            NetworkManage.shared.fetchDataSearch(
                url: search.next ?? "",
                progressDownload: { progressDownload in
//                    self.progressView.setProgress(Float(progressDownload.fractionCompleted),
//                                                  animated: true)
                    
                },
                completion: {
                    search in self.search = search
                    self.activityIndicator.stopAnimating()
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
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            backButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            nextButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
            nextLabel.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 20),
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
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.result = search.results?[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
