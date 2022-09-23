//
//  CollectionMyLibraryCell.swift
//  English Book
//
//  Created by mac on 21.07.2022.
//

import UIKit

final class CollectionMyLibraryCell: UICollectionViewCell {
    
    static let identifier = "CollectionMyLibraryCell"
    
    let imageViewBook: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let nameBookLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .black)
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
        imageViewBook.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - 20)
        nameBookLabel.frame = CGRect(x: 0, y: imageViewBook.frame.height + 10, width: contentView.frame.width, height: 20)
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 9
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 5, height: 8)
    }
    
    func configure(with dataImage: Data?, title: String) {
        guard let dataImage = dataImage else { return }
        imageViewBook.image = UIImage(data: dataImage)
        nameBookLabel.text = title
    }
    
    func configure(with namedImage: String, title: String) {
        imageViewBook.image = UIImage(named: namedImage)
        nameBookLabel.text = title
    }

}
