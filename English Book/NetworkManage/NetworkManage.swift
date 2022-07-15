//
//  NetworkManage.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import Foundation

class NetworkManage {
    static let shared = NetworkManage()
    private init() {}
    
    func fetchListOfSearch(url: String, completion: @escaping(Search) -> Void ) {
        guard let urlType = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: urlType) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Нет описания ошибки")
                return
            }
            do {
                let cocktails = try JSONDecoder().decode(Search.self, from: data)
                DispatchQueue.main.async {
                    completion(cocktails)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchDataImage(from url: URL, completion: @escaping(Data, URLResponse) -> Void ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "Нет описания ошибки")
                return}
            
            // Доп проверка на url для коректного отображения в таблице
            guard url == response.url else { return }
            
            DispatchQueue.main.async {
                completion(data, response)
            }
            
        }.resume()
    }
}
