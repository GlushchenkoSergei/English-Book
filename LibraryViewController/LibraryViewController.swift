//
//  MainViewController.swift
//  English Book
//
//  Created by mac on 16.07.2022.
//

import UIKit

protocol LibraryViewControllerDelegate: AnyObject {
    func savedNewBook()
}

class LibraryViewController: UIViewController {
    
    private let bottomLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionMyLibrary: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.isHidden = true
        return progressView
    }()
    
    var books: [BookCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Библиотека"
        view.backgroundColor = .systemBackground
        collectionMyLibrary.register(CollectionMyLibraryCell.self, forCellWithReuseIdentifier: CollectionMyLibraryCell.identifier)
        collectionMyLibrary.dataSource = self
        collectionMyLibrary.delegate = self

        view.addSubview(bottomLabelView)
        view.addSubview(collectionMyLibrary)
        view.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 1.5, height: 50)
        progressView.center = view.center
        
        guard let book = StorageManager.shared.fetchDataBook()  else { return }
        books = book
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstrains()
    }

}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      books.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionMyLibraryCell.identifier, for: indexPath) as! CollectionMyLibraryCell
        
        if indexPath.row == 0 {
            cell.configure(with: "searchBook", title: "Search")
        } else {
            guard let imageURL = books[indexPath.row - 1].image else { return UICollectionViewCell() }
            NetworkManage.shared.fetchResponseFrom(url: imageURL) { response in
                cell.configure(with: response.data, title: self.books[indexPath.row - 1].title ?? "")
            }
        }

        return cell
        
    }
    
    // Переход на PageVC по выбранной книге
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let searchVC = SearchViewController()
            searchVC.delegate = self
            navigationController?.pushViewController(searchVC, animated: true)
        } else {
            progressView.isHidden = false
            let book = books[indexPath.row - 1]
            var pagesOfBook: [String] = []
            
            TextAssistant.shared.divideTextIntoPages(
                text: book.body ?? "",
                progress: { progress in
                    self.progressView.setProgress(Float(progress/100), animated: true)
                },
                completion: { [weak self] pages in
                    self?.progressView.isHidden = true
                    self?.progressView.setProgress(0, animated: true)
                    pagesOfBook = pages
                    let pageVC = PageViewController()
                    
                    let configurator: PageConfiguratorInputProtocol = PageConfigurator()
                    configurator.configure(with: pageVC, and: pagesOfBook, nameBook: book.title ?? "")
                    self?.navigationController?.pushViewController(pageVC, animated: true)
                })
            
        }
    }
    
    // Размер ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.width / 3) - 30, height: view.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}

extension LibraryViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            collectionMyLibrary.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionMyLibrary.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionMyLibrary.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomLabelView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bottomLabelView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
}

extension LibraryViewController: LibraryViewControllerDelegate {
    
    func savedNewBook() {
        guard let book = StorageManager.shared.fetchDataBook()  else { return }
        books = book
        collectionMyLibrary.reloadData()
    }
    
}
