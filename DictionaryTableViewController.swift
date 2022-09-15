//
//  DictionaryTableViewController.swift
//  English Book
//
//  Created by mac on 21.07.2022.
//

import UIKit

class DictionaryTableViewController: UITableViewController {
    
   private var learnTheseWords: [LearnWord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButtonItems([editButtonItem], animated: true)
        title = "Словарь"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellWord")
        learnTheseWords = StorageManager.shared.fetchLearnWords() ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        learnTheseWords = StorageManager.shared.fetchLearnWords() ?? []
        tableView.reloadData()
    }

    // MARK: - Table view data source
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let wordCD = learnTheseWords[indexPath.row]
        _ = StorageManager.shared.appendIKnowWord(title: wordCD.word ?? "")
        
        StorageManager.shared.delete(wordCD)
        learnTheseWords.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}
