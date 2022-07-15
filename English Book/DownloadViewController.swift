//
//  DownloadViewController.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import UIKit

class DownloadViewController: UIViewController {

    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(nextLabel)
        view.addSubview(countLabel)
        
        
        tableView.rowHeight = 80
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    
        downloadData()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstrains()
    }
    
    private func downloadData() {
        NetworkManage.shared.fetchListOfSearch(url: LinK.searchBooks.rawValue) { search in
            self.search = search
        }
    }
    
    @objc private func backButtonAction() {
        if search.previous != nil {
            NetworkManage.shared.fetchListOfSearch(url: search.previous ?? "") { search in
                self.search = search
            }
        }
    }
    
    @objc private func nextButtonAction() {
        if search.next != nil {
            NetworkManage.shared.fetchListOfSearch(url: search.next ?? "") { search in
                self.search = search
            }
        }
    }
    private func getNumberOfPage(string: String?) -> String {
       let string = string?.components(separatedBy: "http://gutendex.com/books/?mime_type=text%2F&page=").last ?? ""
        let page = (Int(string) ?? 0) - 1
        return String(page)
    }
   
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            backButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30)
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }

}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        results.count
        search.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
//        content.text = results[indexPath.row].title
//        content.secondaryText = results[indexPath.row].authors?.first?.name
        content.text = search.results?[indexPath.row].title
        content.secondaryText = search.results?[indexPath.row].authors?.first?.name
        
        if let url = URL(string: search.results?[indexPath.row].formats.imageJPEG ?? "") {
            NetworkManage.shared.fetchDataImage(from: url) { data, response in
//                print(response) для кэширования изображений
                content.image = UIImage(data: data)
                cell.contentConfiguration = content
            }
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.result = search.results?[indexPath.row]
        present(UINavigationController(rootViewController: detailVC), animated: true)
    }
    
    
}
