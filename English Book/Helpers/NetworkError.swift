//
//  NetworkError.swift
//  English Book
//
//  Created by mac on 16.09.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
