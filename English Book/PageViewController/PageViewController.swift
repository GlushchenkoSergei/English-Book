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
        collectionView.isScrollEnabled = false
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
    
    private let detailViewWord: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
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
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iKnowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5390633941, green: 0.8859668374, blue: 0.3078767955, alpha: 1)
        button.setTitle("i know", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let learnButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.411550343, green: 0.1191236749, blue: 0.7548881769, alpha: 0.8955446963)
        button.setTitle("learn", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.isHidden = true
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
    
    private var iKnowTheseWords: [WordIKnow] = []
    private var learnTheseWords: [LearnWord] = []
    
    private var indexPathItem: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        
        guard let wordsIKnowCD = StorageManager.shared.fetchWordsIKnow() else { return }
        iKnowTheseWords = wordsIKnowCD
        
        guard let wordsLearnCD = StorageManager.shared.fetchLearnWords() else { return }
        learnTheseWords = wordsLearnCD
        
        title = nameBook
        view.backgroundColor = .systemBackground
        let testGesture = UITapGestureRecognizer(target: self, action: #selector(testTapGesture(sender: )))
        collectionView.addGestureRecognizer(testGesture)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        allPagesLabel.text = "\(pagesOfBook.count) pages"
        
        view.addSubview(collectionView)
        view.addSubview(nextPageButton)
        view.addSubview(backPageButton)
        view.addSubview(allPagesLabel)
        view.addSubview(detailViewWord)
        
        detailViewWord.addSubview(translateWord)
        detailViewWord.addSubview(originalWord)
        detailViewWord.addSubview(iKnowButton)
        detailViewWord.addSubview(learnButton)

        detailViewWord.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 1.5, height: view.bounds.height / 5)
        
        setConstraints()
        componentsOfPage = divisionIntoParts(this: pagesOfBook[currentPage - 1])
        addingSpacerForLine()
        createArrayWidthCell()
        
        nextPageButton.addTarget(self, action: #selector(nextPageButtonTap), for: .touchUpInside)
        backPageButton.addTarget(self, action: #selector(backPageButtonTap), for: .touchUpInside)
        iKnowButton.addTarget(self, action: #selector(iKnowButtonTap), for: .touchUpInside)
        learnButton.addTarget(self, action: #selector(learnButtonTap), for: .touchUpInside)
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        componentsOfPage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as! WordCollectionViewCell
        
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        cell.configure(with: componentsOfPage[indexPath.row], sizeMask: getSizeMask(text: word))
        
        
        let containerIKnow = iKnowTheseWords.filter { $0.word == word }
        cell.maskTextView.backgroundColor = !containerIKnow.isEmpty ? #colorLiteral(red: 0.5390633941, green: 0.8859668374, blue: 0.3078767955, alpha: 1) : #colorLiteral(red: 0.825511992, green: 0.825511992, blue: 0.825511992, alpha: 1)
        
        if containerIKnow.isEmpty {
        let containerLearn = learnTheseWords.filter { $0.word == word }
        cell.maskTextView.backgroundColor = !containerLearn.isEmpty ? #colorLiteral(red: 0.411550343, green: 0.1191236749, blue: 0.7548881769, alpha: 0.8955446963) : #colorLiteral(red: 0.825511992, green: 0.825511992, blue: 0.825511992, alpha: 1)
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
    
    // MARK: - Modifide testTapGesture of CollectionView
    @objc private func testTapGesture(sender: UILongPressGestureRecognizer) {
        
        let locationView = sender.location(in: view)
        let locationCollectionView = sender.location(in: collectionView)

        guard let indexPath = collectionView.indexPathForItem(at: locationCollectionView) else { return }
        indexPathItem = indexPath
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        
        hiddenDetailViewWord(value: false)

        detailViewWord.frame.origin = setPositionDetailViewWord(locationCollectionView, locationView)
        detailViewWord.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.2) { self.detailViewWord.transform = .identity }

        originalWord.text = word
        translateWord.text = TranslateManager.translate(word: word)
    }
    
    
    @objc private func iKnowButtonTap() {
        guard let indexPath = indexPathItem else { return }
        
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        var isContains = false
        
        for wordIKnow in iKnowTheseWords {
            if wordIKnow.word == word {
                StorageManager.shared.delete(wordIKnow)
                let indexFind = iKnowTheseWords.firstIndex(of: wordIKnow)
                iKnowTheseWords.remove(at: indexFind ?? 0)
                isContains = true
                break
            }
        }
        
            if !isContains {
        guard let wordCoreData = StorageManager.shared.appendIKnowWord(title: word) else { return }
        iKnowTheseWords.append(wordCoreData)
        }
    
        collectionView.reloadData()
        hiddenDetailViewWord(value: true)
    }
    
    @objc private func learnButtonTap() {
        guard let indexPath = indexPathItem else { return }
        
        let word = removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        let containerLearn = learnTheseWords.filter { $0.word == word }
        
        if !containerLearn.isEmpty {
            StorageManager.shared.delete(containerLearn.first!)
            let indexFind = learnTheseWords.firstIndex(of: containerLearn.first!)
            learnTheseWords.remove(at: indexFind ?? 0)
        }
        
        if containerLearn.isEmpty {
            guard let learnWord = StorageManager.shared.appendLearnWord(title: word) else { return }
            learnTheseWords.append(learnWord)
        }
        
        collectionView.reloadData()
        hiddenDetailViewWord(value: true)
    }
    
    private func hiddenDetailViewWord(value: Bool) {
        detailViewWord.isHidden = value
        translateWord.isHidden = value
        originalWord.isHidden = value
        learnButton.isHidden = value
        iKnowButton.isHidden = value
    }
    
    private func setPositionDetailViewWord(_ locationCollectionView: CGPoint, _ locationView: CGPoint) -> CGPoint {
        
        var valueX: CGFloat = 0
        var valueY: CGFloat = 0
        
        switch locationCollectionView.x {
        case ...CGFloat(detailViewWord.frame.width / 2):
            valueX = locationView.x
        case CGFloat(detailViewWord.frame.width / 2) + 1...view.bounds.width - detailViewWord.frame.width / 2:
            valueX = locationView.x - detailViewWord.frame.width / 2
        default:
            valueX = locationView.x - detailViewWord.frame.width
        }
        
        switch locationCollectionView.y {
        case ...detailViewWord.frame.height:  valueY = locationView.y + 20
        default: valueY = locationView.y - detailViewWord.bounds.height - 20
        }
        
        return CGPoint(x: valueX, y: valueY)
    }
    
}

  
// MARK: - UICollectionViewDelegateFlowLayout
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


// MARK: - Set constraints
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
            originalWord.topAnchor.constraint(equalTo: detailViewWord.topAnchor, constant: 20),
            originalWord.centerXAnchor.constraint(equalTo: detailViewWord.centerXAnchor),
            originalWord.heightAnchor.constraint(equalToConstant: detailViewWord.frame.height / 6)
        ])
        
        NSLayoutConstraint.activate([
            translateWord.topAnchor.constraint(equalTo: originalWord.bottomAnchor, constant: 20),
            translateWord.centerXAnchor.constraint(equalTo: detailViewWord.centerXAnchor),
            translateWord.heightAnchor.constraint(equalToConstant: detailViewWord.frame.height / 4),
            translateWord.widthAnchor.constraint(equalToConstant: detailViewWord.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            iKnowButton.heightAnchor.constraint(equalToConstant:  detailViewWord.frame.height / 4),
            iKnowButton.leadingAnchor.constraint(equalTo: detailViewWord.leadingAnchor),
            iKnowButton.widthAnchor.constraint(equalToConstant: detailViewWord.frame.width / 2),
            iKnowButton.bottomAnchor.constraint(equalTo: detailViewWord.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            learnButton.topAnchor.constraint(equalTo: iKnowButton.topAnchor),
            learnButton.trailingAnchor.constraint(equalTo: detailViewWord.trailingAnchor),
            learnButton.widthAnchor.constraint(equalToConstant: detailViewWord.frame.width / 2),
            learnButton.bottomAnchor.constraint(equalTo: detailViewWord.bottomAnchor)
        ])
        
    }
    
}

