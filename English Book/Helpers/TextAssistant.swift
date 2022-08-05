//
//  TextAssistant.swift
//  English Book
//
//  Created by mac on 23.07.2022.
//

import UIKit

class TextAssistant {
    static let shared = TextAssistant()
    private init() {}
    
    func divideTextIntoPages(text: String, progress: @escaping(CGFloat) -> Void, completion: @escaping([String]) -> Void) {
        
        DispatchQueue.global().async {
            var pagesOfBook: [String] = []
            
            let diverseCount = Int(text.count / 400)
            var location = 0
            
            let valueOnePercent = CGFloat(100)/CGFloat(diverseCount)
            var counter = 0
            
            for _ in 0..<diverseCount - 1 {
                
                pagesOfBook.append(String(
                    text[text.index(text.startIndex, offsetBy: location)..<text.index(text.startIndex, offsetBy: location + 400)]
                ))
                
                location += 400
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
    
    func addingSpacerForLine(_ componentsOfPage: inout [String]) {
        var value = 0
        var counterOneLine = 0
        
        for index in 0...componentsOfPage.count - 1 {
            
            value += componentsOfPage[index].count
            
            if value > 31 {
                let x = 31 - counterOneLine
                guard x > 0 else { return }
                for _ in 0...x {
                    componentsOfPage[index - 1] += " "
                }
                counterOneLine = 0
                value = componentsOfPage[index].count
            }
            
            counterOneLine += componentsOfPage[index].count
        }
    }
    
}
