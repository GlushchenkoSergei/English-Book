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
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .systemGray2
        button.isEnabled = false
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let openPageVCButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Читать", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.isHidden = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    let progressMask: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.8166104752)
        view.isHidden = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var originalPosition: CGPoint = {
     downloadButton.frame.origin
    }()
    
    var mainText = "" {
        didSet {
               openPageVCButton.isHidden = false
        }
    }
    var pagesOfBook: [String] = []
    var finishDiverse = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        title = result.title
        
        if checkZip(string: result.formats.textPlainCharsetUtf8) {
            downloadButton.isEnabled = true
            downloadButton.backgroundColor = .blue
        } else {
            downloadButton.setTitle("Нет данных", for: .normal)
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
        view.addSubview(downloadButton)
        view.addSubview(openPageVCButton)
        view.addSubview(progressMask)
        
        downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
        openPageVCButton.addTarget(self, action: #selector(openPageVCButtonAction), for: .touchUpInside)
        setImage()
        setConstrains()
    }
    
    
    
    @objc private func openPageVCButtonAction() {
        progressMask.isHidden = false
        openPageVCButton.backgroundColor = .white
        
        divideTextIntoPages(
            text: mainText,
            progressForMask: { [weak self] progress in
                self?.progressMask.frame = CGRect(x: self?.openPageVCButton.frame.origin.x ?? 0,
                                                y: self?.openPageVCButton.frame.origin.y ?? 0,
                                                width: (self?.openPageVCButton.frame.width ?? 0) * progress / 100,
                                                height: 50)
                self?.openPageVCButton.setTitle("\(Int(progress)) % completed", for: .normal)
            },
            completion: { [weak self] pagesOfBook in
                self?.pagesOfBook = pagesOfBook
                
                StorageManager.shared.saveBook(title: self?.result.title ?? "",
                                            image: self?.result.formats.imageJPEG ?? "",
                                            pages: self?.pagesOfBook ?? [])
                
                let pageVC = PageViewController()
                pageVC.pagesOfBook = self?.pagesOfBook ?? []
                pageVC.nameBook = self?.result.title ?? ""
                self?.navigationController?.pushViewController(pageVC, animated: true) }
        )
    }
    
    @objc private func downloadButtonAction() {
        progressMask.isHidden = false
        downloadButton.backgroundColor = .white
        downloadButton.setTitle("0 % completed", for: .normal)
        
        guard let url = result.formats.textPlainCharsetUtf8 else { return }
        NetworkManage.shared.fetchDataFrom(url: url) { progress in
            self.progressMask.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.downloadButton.frame.width * CGFloat(progress.fractionCompleted),
                                           height: 50)
            self.progressMask.frame.origin = self.originalPosition
            self.downloadButton.setTitle(progress.localizedDescription, for: .normal)
            
        } completion: { data in
            
            self.progressMask.isHidden = true
            self.downloadButton.backgroundColor = .systemGray2
            self.downloadButton.setTitle("Download", for: .normal)
            self.mainText = String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    private func divideTextIntoPages(text: String, progressForMask: @escaping(CGFloat) -> Void, completion: @escaping([String]) -> Void) {
        
        DispatchQueue.global().async {
            var pagesOfBook: [String] = []
            
            let diverseCount = Int(text.count / 450)
            var location = 0
            
            let valueOnePercent = CGFloat(100)/CGFloat(diverseCount)
            var counter = 0
            
            for _ in 0..<diverseCount - 1 {
                
                pagesOfBook.append(String(
                    text[text.index(text.startIndex, offsetBy: location)..<text.index(text.startIndex, offsetBy: location + 450)]
                ))
                
                location += 450
                counter += 1
                
                DispatchQueue.main.async {
                    progressForMask((CGFloat(counter) * valueOnePercent))
                }
            }
            
            DispatchQueue.main.async {
                completion(pagesOfBook)
            }
        }
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
        guard let url = result.formats.imageJPEG else { return }
        NetworkManage.shared.fetchResponseFrom(url: url) { response in
            if let data = response.data{
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
            downloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 250),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            openPageVCButton.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20),
            openPageVCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPageVCButton.widthAnchor.constraint(equalToConstant: 250),
            openPageVCButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

//extension DetailViewController: URLSessionDownloadDelegate {
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//
//        print("Локация\(location)")
//        guard let url = downloadTask.originalRequest?.url else { return }
////        print(url)
//        print("ЮРЛ\(url)")
//        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
//
////        try? FileManager.default.removeItem(at: destinationPath)
//
//        do {
//            try FileManager.default.copyItem(at: location, to: destinationPath)
//            fileURL = destinationPath
//        } catch let error{
//            print(error.localizedDescription)
//        }
//
//    }
//
//}
