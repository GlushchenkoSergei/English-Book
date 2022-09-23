//
//  TextAssistant.swift
//  English Book
//
//  Created by mac on 23.07.2022.
//

import UIKit

final class TextAssistant {
    static let shared = TextAssistant()
    private init() {}
    
    func divideTextIntoPages(text: String, progress: @escaping(CGFloat) -> Void, completion: @escaping([String]) -> Void) {
        
        DispatchQueue.global().async {
            var pagesOfBook: [String] = []
            
            let diverseCount = Int(text.count / 380)
            var location = 0
            
            let valueOnePercent = CGFloat(100)/CGFloat(diverseCount)
            var counter = 0
            
            for _ in 0..<diverseCount - 1 {
                
                pagesOfBook.append(String(
                    text[text.index(text.startIndex, offsetBy: location)..<text.index(text.startIndex, offsetBy: location + 380)]
                ))
                
                location += 380
                counter += 1
                
                DispatchQueue.main.async {
                    progress((CGFloat(counter) * valueOnePercent))
                }
            }
            
            DispatchQueue.main.async {
                completion(pagesOfBook)
            }
        }
    }
    
    func removePunctuationMarks(this text: String) -> String {
        var string: String = ""
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) { _, substringRange, _, _ in
            string = String(text[substringRange])
        }
        return string
    }
    
    func divisionIntoParts(this text: String) -> [String] {
        var components: [String] = []
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) { _, _, enclosingRange, _ in
            components.append(String(text[enclosingRange]))
        }
        return components
    }
    
    func addingSpacerForLine(_ componentsOfPage: inout [String], widthScreen: Double) {
        let widthScreen = widthScreen - 33
        
        var width: Double = 0
        var counterWidthOneLine: Double = 0
        let widthOneSpacer = CalculationWidthLabel.shared.getSizeMask(" ")
        
        for index in 0...componentsOfPage.count - 1 {

            width += CalculationWidthLabel.shared.getSizeMask(componentsOfPage[index])
            
            if width > widthScreen {
                let valueX = (widthScreen - counterWidthOneLine) / widthOneSpacer

                if Int(valueX) > 0 {
                
                    for _ in 0...Int(valueX) - 1 {
                        componentsOfPage[index - 1] += " "
                    }
                    
                }
                counterWidthOneLine = 0
                width = CalculationWidthLabel.shared.getSizeMask(componentsOfPage[index])
                }
                
            counterWidthOneLine += CalculationWidthLabel.shared.getSizeMask(componentsOfPage[index])
        }

    }
            
}
