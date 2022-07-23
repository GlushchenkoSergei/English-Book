//
//  TestViewController.swift
//  English Book
//
//  Created by mac on 23.07.2022.
//

import UIKit

class TestViewController: UIViewController {
    
    private var iKnowWords: [WordIKnow] = []
    private var learnTheseWords: [LearnWord] = []
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.5
        view.layer.borderWidth = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()
    
    private let iKnowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1956014633, green: 0.601811707, blue: 0.9170701504, alpha: 0.7115000542)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("iKnow", for: .normal)
        button.layer.shadowRadius = 15
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forgotButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5742451549, green: 0, blue: 0, alpha: 0.3554331798)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("forgot", for: .normal)
        button.layer.shadowRadius = 15
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let labelWord: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let wordsIKnow = StorageManager.shared.fetchWordsIKnow() else { return }
        guard let wordsLearn = StorageManager.shared.fetchLearnWords() else { return }
        iKnowWords = wordsIKnow
        learnTheseWords = wordsLearn
        
        view.backgroundColor = .white
        title = "Test"
        
        view.addSubview(cardView)
        view.addSubview(iKnowButton)
        view.addSubview(forgotButton)
        view.addSubview(labelWord)
        setConstrains()
        
        labelWord.text = iKnowWords.randomElement()?.word
        
        iKnowButton.addTarget(self, action: #selector(iKnowButtonTap), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(forgotButtonTap), for: .touchUpInside)
    }
    
    @objc private func iKnowButtonTap() {
        labelWord.text = iKnowWords.randomElement()?.word
    }
    
    @objc private func forgotButtonTap() {
        guard let word = labelWord.text else { return }
    
        for iKnowWord in iKnowWords {
            if iKnowWord.word == word {
                StorageManager.shared.delete(iKnowWord)
                let indexFind = iKnowWords.firstIndex(of: iKnowWord)
                iKnowWords.remove(at: indexFind ?? 0)
                break
            }
            
            let _ = StorageManager.shared.appendLearnWord(title: word)
            labelWord.text = iKnowWords.randomElement()?.word
        }
    }
    
}

extension TestViewController {
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3 ),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            cardView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4)
        ])
        
        NSLayoutConstraint.activate([
            iKnowButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 100),
            iKnowButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3),
            iKnowButton.heightAnchor.constraint(equalToConstant: 50),
            iKnowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            forgotButton.topAnchor.constraint(equalTo: iKnowButton.bottomAnchor, constant: 30),
            forgotButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3),
            forgotButton.heightAnchor.constraint(equalToConstant: 50),
            forgotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelWord.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            labelWord.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
}


