//
//  DetailViewController.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var result: Result!
    
    
    let imageBook: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageBook)
        imageBook.center = view.center
        navigationController?.navigationBar.prefersLargeTitles = true
        title = result.title
        setImage()
    
    }
    
    private func setImage() {
        if let url = URL(string: result.formats.imageJPEG ?? "") {
            NetworkManage.shared.fetchDataImage(from: url) { data, _ in
                self.imageBook.image = UIImage(data: data)
            }
        }
    }
    
    
}
