//
//  NetworkManage.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import Foundation
import Alamofire

class NetworkManage {
    static let shared = NetworkManage()
    private init() {}
    

    func fetchDataSearch(url: String, progressDownload: @escaping(Progress) -> Void, completion: @escaping(Search) -> Void) {
        request(url)
            .downloadProgress(closure: { progress in
                progressDownload(progress)
            })
            .response { response in
                guard let data = response.data else { return }
                do {
                    let cocktails = try JSONDecoder().decode(Search.self, from: data)
                        completion(cocktails)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func fetchDataFrom(url: String, progressDownload: @escaping(Progress) -> Void, completion: @escaping(Data) -> Void) {
        
        request(url)
            .downloadProgress(closure: { progress in
                progressDownload(progress)
            })
            .response { response in
                if let data = response.data {
                    completion(data)
                }
            }
        
    }
    
    func fetchResponseFrom(url: String, completion: @escaping(DefaultDataResponse) -> Void) {
        request(url)
            .response { response in
                    completion(response)
                }
    }
    
}
