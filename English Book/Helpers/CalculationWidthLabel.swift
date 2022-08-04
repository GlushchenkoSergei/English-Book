//
//  CalculationWidthLabel.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//


import UIKit

class CalculationWidthLabel {
    static let shared = CalculationWidthLabel()
    private init() {}
    
    // Для подсчета ширины cell
    private let labelForCountingWidthCell: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .black)
        return label
    }()
    
    
    func createArrayWidthCells(_ componentsOfPage: [String]) -> [Double] {
        var sizesForCells: [Double] = []
        
        sizesForCells.removeAll()
        for component in componentsOfPage {
            labelForCountingWidthCell.text = component
            labelForCountingWidthCell.sizeToFit()
            sizesForCells.append(labelForCountingWidthCell.frame.width)
        }
        return sizesForCells
    }
    
    func getSizeMask(_ text: String) -> Double {
        labelForCountingWidthCell.text = text
        labelForCountingWidthCell.sizeToFit()
        let size = labelForCountingWidthCell.frame.width
        return size
    }
    
}
