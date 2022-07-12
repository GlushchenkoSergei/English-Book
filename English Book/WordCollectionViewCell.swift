//
//  WordCollectionViewCell.swift
//  English Book
//
//  Created by mac on 12.07.2022.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WordCollectionViewCell"
    
   private let textLabel: UILabel = {
       let label = UILabel()
        label.text = "text"
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
//        textLabel.textColor = .red
        contentView.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with word: String) {
        textLabel.text = word
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//    }
    
    
}
