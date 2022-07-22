//
//  PageViewController.swift
//  English Book
//
//  Created by mac on 11.07.2022.
//

import UIKit

class PageViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    private let allPagesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backPageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.isHidden = true
        return view
    }()
    
    private let originalWord: UILabel = {
        let label = UILabel()
        label.text = "originalWord"
        label.isHidden = true

        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translateWord: UILabel = {
        let label = UILabel()
        label.text = "translateWord"
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iKnowButton: UIButton = {
        let button = UIButton()
        button.setTitle("i know", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let learnButton: UIButton = {
        let button = UIButton()
        button.setTitle("learn", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var pagesOfBook: [String] = []
    var nameBook = ""
    
    // Для подсчета ширины cell
    private let labelForCountingWidthCell: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .black)
        return label
    }()
   
    private var currentPage = 1 {
        didSet{
            componentsOfPage = divisionIntoParts(this: pagesOfBook[currentPage - 1])
            addingSpacerForLine()
            createArrayWidthCell()
            collectionView.reloadData()
        }
    }
    
    private var value = 0
    private var counterOneLine = 0
    
    private var componentsOfPage: [String] = []
    private var sizesForCells: [Double] = []
    
    private var wordsCoreData: [WordIKnow] = []
    
//    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let words = StorageManager.shared.fetchData() else { return }
        wordsCoreData = words
        
        title = nameBook
        view.backgroundColor = .systemBackground
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        allPagesLabel.text = "\(pagesOfBook.count) pages"
        
        view.addSubview(collectionView)
        view.addSubview(nextPageButton)
        view.addSubview(backPageButton)
        view.addSubview(allPagesLabel)
        

//        blurEffectView.isHidden = true
//        blurEffectView.alpha = 0.9
//        blurEffectView.frame = view.bounds
//        view.addSubview(blurEffectView)
        
        view.addSubview(testView)
        view.addSubview(translateWord)
        view.addSubview(originalWord)
//        testView.frame =
        testView.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 1.5, height: view.bounds.height / 5)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setConstraints()
        componentsOfPage = divisionIntoParts(this: pagesOfBook[currentPage - 1])
        addingSpacerForLine()
        createArrayWidthCell()
        
        nextPageButton.addTarget(self, action: #selector(nextPageButtonTap), for: .touchUpInside)
        backPageButton.addTarget(self, action: #selector(backPageButtonTap), for: .touchUpInside)
        
        
        let testGesture = UITapGestureRecognizer(target: self, action: #selector(testTapGesture(sender: )))
        testGesture.delegate = self
        
        collectionView.addGestureRecognizer(testGesture)
    }
    
    @objc private func nextPageButtonTap() {
        if currentPage < pagesOfBook.count {
        currentPage += 1
        }
    }
    
    @objc private func backPageButtonTap() {
        if currentPage != 1 {
        currentPage -= 1
        }
    }
    
    private func createArrayWidthCell() {
        sizesForCells.removeAll()
        for component in componentsOfPage {
            labelForCountingWidthCell.text = component
            labelForCountingWidthCell.sizeToFit()
            sizesForCells.append(labelForCountingWidthCell.frame.width)
        }
    }
    
    private func addingSpacerForLine() {
        
        for index in 0...componentsOfPage.count - 1 {
            
            value += componentsOfPage[index].count
            
            if value > 31 {
                let x = 31 - counterOneLine
                guard x > 0 else { return }
                for _ in 0...x {
                    componentsOfPage[index - 1] += " "
                }
                counterOneLine = 0
                value = componentsOfPage[index].count
            }
            counterOneLine += componentsOfPage[index].count
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
        componentsOfPage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as! WordCollectionViewCell
        
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        cell.configure(with: componentsOfPage[indexPath.row], sizeMask: getSizeMask(text: word))
        
        
        var isContains = false
        
        for wordCoreData in wordsCoreData {
            if wordCoreData.word == word {
                cell.maskTextView.backgroundColor = #colorLiteral(red: 0.5390633941, green: 0.8859668374, blue: 0.3078767955, alpha: 1)
                isContains.toggle()
                break
            }
        }
        
        if !isContains {
            cell.maskTextView.backgroundColor = #colorLiteral(red: 0.825511992, green: 0.825511992, blue: 0.825511992, alpha: 1)
        }
        
        
//        cell.backgroundColor = .systemGray
        return cell
    }
    
    func getSizeMask(text: String) -> Double {
        labelForCountingWidthCell.text = text
        labelForCountingWidthCell.sizeToFit()
        let size = labelForCountingWidthCell.frame.width
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())

        
        var isContains = false
        
        for wordIKnow in wordsCoreData {
            if wordIKnow.word == word {
                StorageManager.shared.delete(wordIKnow)
                let indexFind = wordsCoreData.firstIndex(of: wordIKnow)
                wordsCoreData.remove(at: indexFind ?? 0)
                isContains = true
                break
            }
        }
        
            if !isContains {
        guard let wordCoreData = StorageManager.shared.save(title: word) else { return }
        wordsCoreData.append(wordCoreData)
        }
        print("стандартное ДАйствие ")
        collectionView.reloadData()
       
        }

    
    @objc private func testTapGesture(sender: UILongPressGestureRecognizer) {
        
        testView.isHidden = false
        translateWord.isHidden = false
        originalWord.isHidden = false
        
        let locationView = sender.location(in: view)
        let locationCollectionView = sender.location(in: collectionView)

        
//        blurEffectView.isHidden = false

        switch locationCollectionView.x {
        case ...CGFloat(testView.frame.width / 2):
            testView.frame.origin.x = locationView.x
        case CGFloat(testView.frame.width / 2) + 1...view.bounds.width - testView.frame.width / 2:
            testView.frame.origin.x = locationView.x - testView.frame.width / 2
        default:
            testView.frame.origin.x = locationView.x - testView.frame.width
        }
        
        switch locationCollectionView.y {
        case ...testView.frame.height:  testView.frame.origin.y = locationView.y + 20
        default:
            testView.frame.origin.y = locationView.y - testView.bounds.height - 20
        }
        
        testView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.2) {
            self.testView.transform = .identity
        }
        

        guard let indexPath = collectionView.indexPathForItem(at: locationCollectionView) else { return }
        
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        
        print(word)
        
        originalWord.text = word
        
//        guard let prepareForTranslate = componentsOfPage[indexPath.row].components(separatedBy: " ").first?.lowercased() else { return }
        translateWord.text = TranslateManager.translate(word: word)
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
            allPagesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height ?? 0) - 10),
            allPagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height ?? 0) - 10),
            nextPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            nextPageButton.heightAnchor.constraint(equalToConstant: 30),
            nextPageButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            backPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height ?? 0) - 10),
            backPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backPageButton.heightAnchor.constraint(equalToConstant: 30),
            backPageButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: backPageButton.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            originalWord.topAnchor.constraint(equalTo: testView.topAnchor, constant: 30),
            originalWord.centerXAnchor.constraint(equalTo: testView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            translateWord.topAnchor.constraint(equalTo: originalWord.bottomAnchor, constant: 30),
            translateWord.centerXAnchor.constraint(equalTo: testView.centerXAnchor)
        ])
        
    }
    
}

