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
    
    private let viewCard: UIView = {
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var wordEn = "" {
        didSet {
            wordRu = TranslateManager.translate(word: wordEn) ?? ""
        }
    }
    private var wordRu = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let wordsIKnow = StorageManager.shared.fetchWordsIKnow() else { return }
        guard let wordsLearn = StorageManager.shared.fetchLearnWords() else { return }
        iKnowWords = wordsIKnow
        learnTheseWords = wordsLearn
        
        view.backgroundColor = .white
        title = "Test"
        
        view.addSubview(viewCard)
        view.addSubview(iKnowButton)
        view.addSubview(forgotButton)
        viewCard.addSubview(labelWord)
        setConstrains()
        
        labelWord.text = iKnowWords.randomElement()?.word
        wordEn = labelWord.text ?? ""
        
        iKnowButton.addTarget(self, action: #selector(iKnowButtonTap), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(forgotButtonTap), for: .touchUpInside)
        
        let testGesture = UITapGestureRecognizer(target: self, action: #selector(testTapGesture(sender: )))
        viewCard.addGestureRecognizer(testGesture)
    }
    
    @objc private func iKnowButtonTap() {
        let value = viewCard.frame.origin.x
        UIView.animate(withDuration: 0.2,
                       animations: {
            self.viewCard.frame.origin = CGPoint(x: -370, y: self.viewCard.frame.origin.y)
            self.iKnowButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            self.labelWord.text = self.iKnowWords.randomElement()?.word
            self.wordEn = self.labelWord.text ?? ""
            self.viewCard.frame.origin = CGPoint(x: 370, y: self.viewCard.frame.origin.y)
            
            UIView.animate(withDuration: 0.2) {
                self.iKnowButton.transform = .identity
                self.viewCard.frame.origin = CGPoint(x: value, y: self.viewCard.frame.origin.y)
            }
        })
        
    }
    
    @objc private func forgotButtonTap() {
        
        UIView.animate(withDuration: 0.2) {
            self.forgotButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) { self.forgotButton.transform = .identity }
        }

    
        for iKnowWord in iKnowWords {
            if iKnowWord.word == wordRu {
                StorageManager.shared.delete(iKnowWord)
                let indexFind = iKnowWords.firstIndex(of: iKnowWord)
                iKnowWords.remove(at: indexFind ?? 0)
                break
            }
        }
        let _ = StorageManager.shared.appendLearnWord(title: wordRu)
        labelWord.text = iKnowWords.randomElement()?.word
        self.wordEn = self.labelWord.text ?? ""
    }
    
    @objc private func testTapGesture(sender: UILongPressGestureRecognizer) {
        let radians = CGFloat(200 * Double.pi / 180)
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(changeTextLabelWord), userInfo: nil, repeats: false)
        
        let rotation = CATransform3DMakeRotation(radians, 0, radians, 0)
        UIView.animate(withDuration: 0.4) {
            self.viewCard.layer.transform = rotation
        } completion: { _ in
            self.labelWord.transform = .identity
            self.viewCard.transform = .identity
        }

    }
    
    @objc private func changeTextLabelWord() {
        labelWord.text = labelWord.text == wordEn ? wordRu : wordEn
        
        let radians = CGFloat(200 * Double.pi / 180)
        let rotation = CATransform3DMakeRotation(radians, 0, radians, 0)
        labelWord.layer.transform = rotation
    }
    
    
}

extension TestViewController {
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            viewCard.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3 ),
            viewCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            viewCard.heightAnchor.constraint(equalToConstant: view.bounds.height / 4)
        ])
        
        NSLayoutConstraint.activate([
            iKnowButton.topAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: 100),
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
            labelWord.centerXAnchor.constraint(equalTo: viewCard.centerXAnchor),
            labelWord.centerYAnchor.constraint(equalTo: viewCard.centerYAnchor),
            labelWord.widthAnchor.constraint(equalTo: viewCard.widthAnchor)
        ])
    }
    
}


