//
//  NetworkManage.swift
//  English Book
//
//  Created by mac on 15.07.2022.
//

import Foundation
import Alamofire

protocol NetworkManageProtocol {
    func fetchDataSearch(
        url: String,
        progressDownload: @escaping(Progress) -> Void,
        completion: @escaping(Swift.Result<Search, NetworkError>) -> Void
    )
    func fetchDataFrom(
        url: String,
        progressDownload: @escaping(Progress) -> Void,
        completion: @escaping(Data) -> Void
    )
    func fetchResponseFrom(
        url: String,
        completion: @escaping(DefaultDataResponse) -> Void
    )
}

final class NetworkManage: NetworkManageProtocol {
    
    func fetchDataSearch(url: String, progressDownload: @escaping(Progress) -> Void, completion: @escaping(Swift.Result<Search, NetworkError>) -> Void) {
        request(url)
            .downloadProgress(closure: { progress in
                progressDownload(progress)
            })
            .response { response in
                guard let data = response.data else {
                    completion(.failure(NetworkError.noData))
                    
                    return
                }
                do {
                    let cocktails = try JSONDecoder().decode(Search.self, from: data)
                    completion(.success(cocktails))
                } catch {
                    completion(.failure(NetworkError.decodingError))
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
