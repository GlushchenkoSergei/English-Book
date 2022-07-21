//
//  CollectionMyLibraryCell.swift
//  English Book
//
//  Created by mac on 21.07.2022.
//

import UIKit

class CollectionMyLibraryCell: UICollectionViewCell {
    
    static let identifier = "CollectionMyLibraryCell"
    
    let imageViewBook: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameBookLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        label.font = UIFont.monospacedSystemFont(ofSize: 10, weight: .black)
        label.contentMode = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(imageViewBook)
        contentView.addSubview(nameBookLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewBook.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - 30)
        nameBookLabel.frame = CGRect(x: 0, y: imageViewBook.frame.height + 10, width: contentView.frame.width, height: 20)
    }
    
    func configure(with dataImage: Data?, title: String) {
        guard let dataImage = dataImage else { return }
        imageViewBook.image = UIImage(data: dataImage)
        nameBookLabel.text = title
    }
    
    
}

