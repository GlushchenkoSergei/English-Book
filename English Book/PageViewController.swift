//
//  PageViewController.swift
//  English Book
//
//  Created by mac on 11.07.2022.
//

import UIKit

class PageViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let nextPageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        return button
    }()
    
    private let backPageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var mainText = """
Practice. Develop a regular practice schedule and devote as much of your free time as possible to improving your talents in your star-making venture. Budding politicians need to practice speeches and public speaking. Musicians need to practice scales. Actors need to rehearse lines and study scenes. Pop stars need to work on their dance moves. Athletes need to train.
Be careful to focus on the proper things. For an actor, it can be tempting to get caught up in superficial things. Updating your social networking, checking TMZ, and other gossip rags isn't "practicing" for being a star. It's wasting time. Study your craft, not the other stuff.
"""
    
    
    // Для подсчета ширины cell
    private let labelForCountingWidthCell: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .black)
        return label
    }()
    private var sizesForCells: [Double] = []
    
    private var value = 0
    private var counterOneLine = 0
    
    private var componentsOfText: [String] = []
    private var selectedWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "English Book"
        view.backgroundColor = .white
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        view.addSubview(nextPageButton)
        view.addSubview(backPageButton)
        
        setConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        componentsOfText = divisionIntoParts(this: mainText)
        addingSpacerForLine(array: componentsOfText)
        createArrayWidthCell()
    }
    
    private func createArrayWidthCell() {
        for component in componentsOfText {
            labelForCountingWidthCell.text = component
            labelForCountingWidthCell.sizeToFit()
            sizesForCells.append(labelForCountingWidthCell.frame.width)
        }
    }
    
    private func addingSpacerForLine(array: [String]) {
        
        for index in 0...componentsOfText.count - 1 {
            
            value += componentsOfText[index].count
            
            if value > 31 {
                let x = 31 - counterOneLine
                for _ in 0...x {
                    componentsOfText[index - 1] += " "
                }
                counterOneLine = 0
                value = componentsOfText[index].count
            }
            counterOneLine += componentsOfText[index].count
        }
    }
    
    private func divisionIntoParts(this text: String) -> [String] {
        var components: [String] = []
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) { _, _, enclosingRange, _ in
            components.append(String(text[enclosingRange]))
        }
        return components
    }
    
    private func removePunctuationMarks(this text: String) -> String {
        var string: String = ""
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) { _, substringRange, _, _ in
            string = String(text[substringRange])
        }
        return string
    }
    
    
}

extension PageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        componentsOfText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as! WordCollectionViewCell
        
        let word = removePunctuationMarks(this: componentsOfText[indexPath.row].lowercased())
        cell.configure(with: componentsOfText[indexPath.row], sizeMask: gesSizeMask(text: word))
        cell.maskTextView.backgroundColor = selectedWords.contains(word) ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.825511992, green: 0.825511992, blue: 0.825511992, alpha: 1)
        
        return cell
    }
    
    func gesSizeMask(text: String) -> Double {
        labelForCountingWidthCell.text = text
        labelForCountingWidthCell.sizeToFit()
        let size = labelForCountingWidthCell.frame.width
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let word = removePunctuationMarks(this: componentsOfText[indexPath.row].lowercased())
        
        if !selectedWords.contains(word) {
            selectedWords.append(word)
        } else {
            let indexFind = selectedWords.firstIndex(of: word) ?? 0
            selectedWords.remove(at: indexFind)
        }
        collectionView.reloadData()
    }
    
}

extension PageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    //расстояние между горизонтальными секциями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    //расстояние между вертикальными разделителями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (sizesForCells[indexPath.row]), height: 30)
    }
}

// Set constraints
extension PageViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
        
        NSLayoutConstraint.activate([
            nextPageButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            nextPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            nextPageButton.heightAnchor.constraint(equalToConstant: 50),
            nextPageButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            backPageButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            backPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backPageButton.heightAnchor.constraint(equalToConstant: 50),
            backPageButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
}

