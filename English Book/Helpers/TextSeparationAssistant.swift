//
//  TextSeparationAssistant.swift
//  English Book
//
//  Created by mac on 23.07.2022.
//

import UIKit

class TextSeparationAssistant {
    
    static func divideTextIntoPages(text: String, progress: @escaping(CGFloat) -> Void, completion: @escaping([String]) -> Void) {
        
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
}
