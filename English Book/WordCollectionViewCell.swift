//
//  WordCollectionViewCell.swift
//  English Book
//
//  Created by mac on 12.07.2022.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WordCollectionViewCell"
    
   let textLabel: UILabel = {
       let label = UILabel()
        label.text = "text"
       label.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .black)
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
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
     
}
