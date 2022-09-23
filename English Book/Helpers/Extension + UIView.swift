//
//  Extension + UIView.swift
//  English Book
//
//  Created by mac on 23.09.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
