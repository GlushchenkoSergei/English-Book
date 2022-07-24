//
//  TranslateManager.swift
//  English Book
//
//  Created by mac on 22.07.2022.
//

import Foundation

class TranslateManager {
    
    static func translate(word: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: "listWords", ofType: "txt") else { return nil}
        guard let data = FileManager.default.contents(atPath: filePath) else { return nil}
        let decodedObject = try? PropertyListDecoder().decode([String: String].self, from: data)
        return(decodedObject?[word] ?? "-")
    }
    
}
