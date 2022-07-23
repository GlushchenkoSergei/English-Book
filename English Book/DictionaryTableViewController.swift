//
//  DictionaryTableViewController.swift
//  English Book
//
//  Created by mac on 21.07.2022.
//

import UIKit

class DictionaryTableViewController: UITableViewController {
    
    private let learnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn words", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

        private let repeatButton: UIButton = {
            let button = UIButton()
            button.setTitle("Repeat", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
    var learnTheseWords: [LearnWord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Dictionary"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellWord")
        guard let words = StorageManager.shared.fetchLearnWords() else { return }
        learnTheseWords = words
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        learnTheseWords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWord", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = learnTheseWords[indexPath.row].word ?? ""
        cell.contentConfiguration = content
        return cell
    }
  

}
