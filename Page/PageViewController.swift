//
//  PageViewController.swift
//  English Book
//
//  Created by mac on 11.07.2022.
//

import UIKit

protocol PageViewControllerInputProtocol: AnyObject {
    func displayTitleBook(with title: String)
    func getComponentsOfPage(with components: [String])
    func getArrayWidthCell(sizesForCells: [Double])
    func displayNumberOfPages(with count: String)
    func displayWordsIKnow(iKnowTheseWords: [WordIKnow])
    func displayWordsLearn(learnTheseWords: [LearnWord])
    func displayCurrentPage(_ page: String)
    func reloadData()
}

protocol PageViewControllerOutputProtocol: AnyObject {
    init(view: PageViewControllerInputProtocol)
    func showPages(with width: Double)
    func getWordsDatabase()
    func nextButtonPressed()
    func backButtonPressed()
    func selectionPage(number: String?)
}

class PageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let nextPageButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray2
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
    
    private let currentPageButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.setTitle("5 стр.", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backPageButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray2
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let detailViewWord: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "maskWord")
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.isHidden = true
        return view
    }()
    
    private let originalWord: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = UIColor(named: "textPage")
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translateWord: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = UIColor(named: "textPage")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iKnowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.5622143149, green: 0.9348329306, blue: 0.3373457193, alpha: 0.4650824338)
        button.setTitle("Знаю", for: .normal)
        button.setTitleColor(UIColor(named: "textPage"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let learnButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.411550343, green: 0.1191236749, blue: 0.7548881769, alpha: 0.4541427915)
        button.setTitle("Учить", for: .normal)
        button.setTitleColor(UIColor(named: "textPage"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var presenter: PageViewControllerOutputProtocol!
    
    private var componentsOfPage: [String] = []
    private var sizesForCells: [Double] = []
    
    private var iKnowTheseWords: [WordIKnow] = []
    private var learnTheseWords: [LearnWord] = []
    
    private var indexPathItem: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.showPages(with: view.bounds.width)
        
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        view.backgroundColor = .systemBackground
        let testGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCollectionView(sender: )))
        collectionView.addGestureRecognizer(testGesture)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(nextPageButton)
        view.addSubview(backPageButton)
        view.addSubview(allPagesLabel)
        view.addSubview(detailViewWord)
        view.addSubview(currentPageButton)
        
        detailViewWord.addSubview(translateWord)
        detailViewWord.addSubview(originalWord)
        detailViewWord.addSubview(iKnowButton)
        detailViewWord.addSubview(learnButton)
        
        detailViewWord.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 1.5, height: view.bounds.height / 5)
        
        setConstraints()
        
        nextPageButton.addTarget(self, action: #selector(nextPageButtonTap), for: .touchUpInside)
        backPageButton.addTarget(self, action: #selector(backPageButtonTap), for: .touchUpInside)
        iKnowButton.addTarget(self, action: #selector(iKnowButtonTap), for: .touchUpInside)
        learnButton.addTarget(self, action: #selector(learnButtonTap), for: .touchUpInside)
        currentPageButton.addTarget(self, action: #selector(currentPageButtonTap), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getWordsDatabase()
        collectionView.reloadData()
    }
    
    @objc private func nextPageButtonTap() {
        presenter.nextButtonPressed()
    }
    
    @objc private func currentPageButtonTap() {
        showAlert()
    }
    
    @objc private func backPageButtonTap() {
        presenter.backButtonPressed()
    }
    
   private func showAlert() {
        let alert = UIAlertController(title: "Выберети страницу", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "от 1 - до \(allPagesLabel.text ?? "")"
        alert.textFields?.first?.keyboardType = .numberPad
        
        let action = UIAlertAction(title: "перейти", style: .cancel) { _ in
            self.presenter.selectionPage(number: alert.textFields?.first?.text)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        componentsOfPage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as! WordCollectionViewCell
        
        let word = TextAssistant.shared.removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        
        cell.configure(with: componentsOfPage[indexPath.row],
                      sizeMask: CalculationWidthLabel.shared.getSizeMask(word))
        
        let containerIKnow = iKnowTheseWords.filter { $0.word == word }
        cell.maskTextView.backgroundColor = !containerIKnow.isEmpty ? UIColor(named: "maskGreen") : UIColor(named: "maskWord")

        if containerIKnow.isEmpty {
            let containerLearn = learnTheseWords.filter { $0.word == word }
            cell.maskTextView.backgroundColor = !containerLearn.isEmpty ? #colorLiteral(red: 0.411550343, green: 0.1191236749, blue: 0.7548881769, alpha: 0.8955446963) : UIColor(named: "maskWord")
        }
        
        return cell
    }
    
    // MARK: - Modified testTapGesture of CollectionView
    @objc private func tapGestureCollectionView(sender: UILongPressGestureRecognizer) {
        
        let locationView = sender.location(in: view)
        let locationCollectionView = sender.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: locationCollectionView) else { return }
        indexPathItem = indexPath
        
        let word = TextAssistant.shared.removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        
        hiddenDetailViewWord(value: false)
        
        detailViewWord.frame.origin = PositionAssistant.shared.setPosition(
            detailViewWord,
            locationCollectionView,
            locationView,
            view
        )
        
        detailViewWord.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.2) { self.detailViewWord.transform = .identity }
        originalWord.text = word
        translateWord.text = TranslateManager.translate(word: word)
    }
    
    @objc private func iKnowButtonTap() {
        guard let indexPath = indexPathItem else { return }
        
        let word = TextAssistant.shared.removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        var isContains = false
        
        for wordLearn in learnTheseWords where wordLearn.word == word {
                StorageManager.shared.delete(wordLearn)
                let indexFind = learnTheseWords.firstIndex(of: wordLearn)
                learnTheseWords.remove(at: indexFind ?? 0)
                break
            }
        
        for wordIKnow in iKnowTheseWords where wordIKnow.word == word {
                StorageManager.shared.delete(wordIKnow)
                let indexFind = iKnowTheseWords.firstIndex(of: wordIKnow)
                iKnowTheseWords.remove(at: indexFind ?? 0)
                isContains = true
                break
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
        
        let word = TextAssistant.shared.removePunctuationMarks(this: componentsOfPage[indexPath.row].lowercased())
        let containerLearn = learnTheseWords.filter { $0.word == word }
        
        for wordIKnow in iKnowTheseWords where wordIKnow.word == word {
                StorageManager.shared.delete(wordIKnow)
                let indexFind = iKnowTheseWords.firstIndex(of: wordIKnow)
                iKnowTheseWords.remove(at: indexFind ?? 0)
                break
            }
        
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
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            currentPageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height ?? 0) - 20),
            currentPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPageButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            allPagesLabel.bottomAnchor.constraint(equalTo: currentPageButton.bottomAnchor, constant: 5),
            allPagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextPageButton.centerYAnchor.constraint(equalTo: currentPageButton.centerYAnchor),
            nextPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            nextPageButton.heightAnchor.constraint(equalToConstant: 40),
            nextPageButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            backPageButton.centerYAnchor.constraint(equalTo: currentPageButton.centerYAnchor),
            backPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            backPageButton.heightAnchor.constraint(equalToConstant: 40),
            backPageButton.widthAnchor.constraint(equalToConstant: 40)
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
            iKnowButton.heightAnchor.constraint(equalToConstant: detailViewWord.frame.height / 4),
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

// MARK: - UICollectionViewDelegateFlowLayout
extension PageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (sizesForCells[indexPath.row]), height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

// MARK: - PageViewControllerInputProtocol
extension PageViewController: PageViewControllerInputProtocol {
    
    func displayTitleBook(with title: String) {
        self.title = title
    }
    
    func displayNumberOfPages(with count: String) {
        self.allPagesLabel.text = count
    }
    
    func getComponentsOfPage(with components: [String]) {
        self.componentsOfPage = components
    }
    
    func displayCurrentPage(_ page: String) {
        currentPageButton.setTitle(page, for: .normal)
    }
    
    func getArrayWidthCell(sizesForCells: [Double]) {
        self.sizesForCells = sizesForCells
    }
    
    func displayWordsIKnow(iKnowTheseWords: [WordIKnow]) {
        self.iKnowTheseWords = iKnowTheseWords
    }
    
    func displayWordsLearn(learnTheseWords: [LearnWord]) {
        self.learnTheseWords = learnTheseWords
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
}
