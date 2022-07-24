//
//  StartTabBarController.swift
//  English Book
//
//  Created by mac on 21.07.2022.
//

import UIKit

class StartTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let libraryVC = UINavigationController(rootViewController: LibraryViewController())
        libraryVC.title = "Библиотека"
        
        let dictionaryVC = UINavigationController(rootViewController: DictionaryTableViewController())
        dictionaryVC.title = "Словарь"
        
        let testVC = TestViewController()
        testVC.title = "Тест"
        
        setViewControllers([libraryVC, dictionaryVC, testVC], animated: true)
        
        guard let items = tabBar.items else { return }
        items[0].image = UIImage(systemName: "books.vertical.fill")
        items[1].image = UIImage(systemName: "text.bubble.fill")
        items[2].image = UIImage(named: "test")
    }
    
}
        


