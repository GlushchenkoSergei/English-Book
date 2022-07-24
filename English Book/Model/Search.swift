//
//  Search.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import Foundation

// MARK: - Search
struct Search: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Result]?
}

// MARK: - Results
struct Result: Codable {
    let id: Int
    let title: String
    let authors: [Author]?
    let languages: [String]
    let formats: Formats
//    let download_count: Int
}

// MARK: - Author
struct Author: Codable {
    let name: String
    let birth_year: Int?
    let death_year: Int?
}

// MARK: - Formats

struct Formats: Codable {
    
    let textPlainCharsetUtf8: String?
    let imageJPEG: String?
    
    enum CodingKeys: String, CodingKey {
        case imageJPEG = "image/jpeg"
        case textPlainCharsetUtf8 = "text/plain; charset=utf-8"
    }
    
}



