//
//  WordCollectionViewCell.swift
//  English Book
//
//  Created by mac on 12.07.2022.
//

import UIKit

final class WordCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WordCollectionViewCell"
    var sizeMask = 0.0
    
   private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        label.textColor = UIColor(named: "textPage")
        label.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .black)
        return label
    }()
    
    let maskTextView: UIView = {
        let view = UIView()
        view.alpha = 0.4
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(maskTextView)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with word: String, sizeMask: Double) {
        textLabel.text = word
        self.sizeMask = sizeMask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
        maskTextView.frame = CGRect(x: 0, y: 0, width: sizeMask, height: textLabel.frame.height)
        maskTextView.layer.cornerRadius = maskTextView.frame.height / 4
    }
    
}
