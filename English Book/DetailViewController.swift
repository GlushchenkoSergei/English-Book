//
//  DetailViewController.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var result: Result!
    
    // Изображение книги
    private let imageBook: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Лэйблы интерфейса
    private let labelBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font.withSize(8)
        label.numberOfLines = 0
        return label
    }()
    
    private let readButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Чиать", for: .normal)
        button.backgroundColor = .systemGray2
        button.isEnabled = false
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let openPageVCButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Открыть", for: .normal)
        button.backgroundColor = .red
        button.isHidden = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    var fileURL: URL? {
        didSet {
            mainText = readFile(url: fileURL)
        }
    }
    
    var mainText = "" {
        didSet {
            DispatchQueue.main.async {
                self.openPageVCButton.isHidden = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = result.title
        
        if checkZip(string: result.formats.textPlainCharsetUtf8) {
            readButton.isEnabled = true
            readButton.backgroundColor = .blue
        } else {
            readButton.setTitle("Нет данных", for: .normal)
        }
        
        labelBook.text = """
\(result.title)\n
Id - [\(result.id)]
languages -\(result.languages) \n
Author: \(result.authors?.first?.name ?? "")
   Birth date: \(result.authors?.first?.birth_year ?? 0)
   Death date: \(result.authors?.first?.death_year ?? 0)
"""
        
        view.addSubview(imageBook)
        view.addSubview(labelBook)
        view.addSubview(readButton)
        view.addSubview(openPageVCButton)
        
        readButton.addTarget(self, action: #selector(readButtonAction), for: .touchUpInside)
        openPageVCButton.addTarget(self, action: #selector(openPageVCButtonAction), for: .touchUpInside)
        setImage()
        setConstrains()
    }
    
    @objc private func openPageVCButtonAction() {
    let pageVC = PageViewController()
    pageVC.mainText = mainText
    navigationController?.pushViewController(pageVC, animated: true)
    }
    
    @objc private func readButtonAction() {
        guard let urlString = result.formats.textPlainCharsetUtf8 else { return }
        guard let url = URL(string: urlString) else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downLoadTask =  urlSession.downloadTask(with: url)
        downLoadTask.resume()
    }
    
    private func readFile(url: URL?) -> String {
        guard let url = url else { return "1"}
        var string = ""
        do {
            try string = String(contentsOf: url)
        } catch let error {
            print(error)
        }
        return string
    }
    
    private func checkZip(string: String?) -> Bool {
        guard let stringURL = result.formats.textPlainCharsetUtf8 else { return false}
        print(stringURL)
        if stringURL.contains(".txt") {
            return true
        } else {
            return false
        }
    }
    
    private func setImage() {
        if let url = URL(string: result.formats.imageJPEG ?? "") {
            NetworkManage.shared.fetchDataImage(from: url) { data, _ in
                self.imageBook.image = UIImage(data: data)
            }
        }
    }
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            imageBook.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageBook.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageBook.heightAnchor.constraint(equalToConstant: 150),
            imageBook.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            labelBook.topAnchor.constraint(equalTo: imageBook.topAnchor),
            labelBook.leadingAnchor.constraint(equalTo: imageBook.trailingAnchor, constant: 20),
            labelBook.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            readButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            readButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readButton.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            openPageVCButton.topAnchor.constraint(equalTo: readButton.bottomAnchor, constant: 20),
            openPageVCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPageVCButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
}

extension DetailViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        
//        try? FileManager.default.removeItem(at: destinationPath)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationPath)
            fileURL = destinationPath
        } catch let error{
            print(error.localizedDescription)
        }
        
    }
    
}
