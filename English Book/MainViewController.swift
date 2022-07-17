//
//  MainViewController.swift
//  English Book
//
//  Created by mac on 16.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let backgroundViewLibrary: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundViewDictionary: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let libraryLabel: UILabel = {
        let view = UILabel()
        view.text = "Library"
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dictionaryLabel: UILabel = {
        let view = UILabel()
        view.text = "Dictionary"
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myLibraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("My library", for: .normal)
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search book", for: .normal)
        return button
    }()
    
    
    private let repeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Repeat", for: .normal)
        return button
    }()
    
    private let learnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn words", for: .normal)
        return button
    }()
    
    private let color3 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
    private let color2 = UIColor(red: 33/255, green: 78/255, blue: 132/255, alpha: 0.40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "English Book"
        addSubview(someViews: [backgroundViewLibrary, backgroundViewDictionary, bottomLabelView,
                               libraryLabel, myLibraryButton, searchButton, dictionaryLabel,
                               learnButton, repeatButton])
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        addTarget()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setPropertyButtons(buttons: [myLibraryButton, searchButton, repeatButton, learnButton])
        setConstrains()
        addGradients()
    }
    
    private func addTarget() {
        myLibraryButton.addTarget(self, action: #selector(tapMyLibraryButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(tapRepeatButton), for: .touchUpInside)
        learnButton.addTarget(self, action: #selector(tapLearnButton), for: .touchUpInside)
    }
    
    @objc private func tapMyLibraryButton() {
        
    }
    @objc private func tapSearchButton() {

        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    @objc private func tapRepeatButton() {
      
    }
    @objc private func tapLearnButton() {
       
    }
    
    private func addSubview(someViews: [UIView]) {
        someViews.forEach { someView in
            view.addSubview(someView)
        }
    }
    
    private func setPropertyButtons(buttons: [UIButton]) {
        buttons.forEach { button in
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addGradient(colors: [color2, color3],
                               startPoint: Point.leading.point,
                               endPoint: Point.trailing.point)
        }
        
    }
    
    private func addGradients() {
        backgroundViewLibrary.addGradient(colors: [color2, color3],
                                          startPoint: Point.leading.point,
                                          endPoint: Point.trailing.point)
        
        backgroundViewDictionary.addGradient(colors: [color2, color3],
                                             startPoint: Point.leading.point,
                                             endPoint: Point.trailing.point)
    }
    
}
extension MainViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            backgroundViewLibrary.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
            backgroundViewLibrary.widthAnchor.constraint(equalToConstant: view.bounds.width),
            backgroundViewLibrary.heightAnchor.constraint(equalToConstant: view.bounds.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            libraryLabel.topAnchor.constraint(equalTo: backgroundViewLibrary.topAnchor, constant: 20),
            libraryLabel.leadingAnchor.constraint(equalTo: backgroundViewLibrary.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            myLibraryButton.topAnchor.constraint(equalTo: libraryLabel.topAnchor, constant: 40),
            myLibraryButton.leadingAnchor.constraint(equalTo: backgroundViewLibrary.leadingAnchor),
            myLibraryButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: libraryLabel.topAnchor, constant: 40),
            searchButton.leadingAnchor.constraint(equalTo: myLibraryButton.trailingAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
        
        NSLayoutConstraint.activate([
            backgroundViewDictionary.topAnchor.constraint(equalTo: backgroundViewLibrary.bottomAnchor, constant: 20),
            backgroundViewDictionary.widthAnchor.constraint(equalToConstant: view.bounds.width),
            backgroundViewDictionary.heightAnchor.constraint(equalToConstant: view.bounds.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            dictionaryLabel.topAnchor.constraint(equalTo: backgroundViewDictionary.topAnchor, constant: 20),
            dictionaryLabel.leadingAnchor.constraint(equalTo: backgroundViewDictionary.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            learnButton.topAnchor.constraint(equalTo: dictionaryLabel.topAnchor, constant: 40),
            learnButton.leadingAnchor.constraint(equalTo: backgroundViewDictionary.leadingAnchor),
            learnButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
        
        NSLayoutConstraint.activate([
            repeatButton.topAnchor.constraint(equalTo: dictionaryLabel.topAnchor, constant: 40),
            repeatButton.leadingAnchor.constraint(equalTo: learnButton.trailingAnchor),
            repeatButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabelView.topAnchor.constraint(equalTo: backgroundViewDictionary.bottomAnchor, constant: 20),
            bottomLabelView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bottomLabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}


