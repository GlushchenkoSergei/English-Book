//
//  Extension + UIView.swift
//  English Book
//
//  Created by mac on 16.07.2022.
//

import UIKit

extension UIView {

    func addGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        var arrayColor: [Any] = []
        
        colors.forEach { color in
            arrayColor.append(color.cgColor)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = arrayColor
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
