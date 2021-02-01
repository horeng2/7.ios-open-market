//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum OpenMarketAPIError: Error {
    case dataDecodingError
    case clientSideError
    case serverSideError
    case noData
    case noResponse
    case wrongURL
    case unknown
}

class OpenMarketAPI {
    
    private static var session = URLSession(configuration: .default)
    private static var ephemeralSession = URLSession(configuration: .ephemeral)
    
    static func request<T: Decodable>(_ type: RequestType, _ completionHandler: @escaping (Result<T, Error>) -> Void) {
            guard let url = URLManager.makeURL(type: type) else {
                print("URL Error")
                return
            }
            session.dataTask(with: url) { (data, response, error) in
                let result = Network.getResult(T.self, data: data, response: response, error: error)
                completionHandler(result)
            }.resume()
        }
    
    static func postItem(_ type: RequestType, itemToPost: ItemToPost, _ completionHandler: @escaping(Result<ItemAfterPost, Error>) -> Void) {
        guard let url = URLManager.makeURL(type: type) else {
            completionHandler(.failure(OpenMarketAPIError.wrongURL))
            return
        }
        // TODO: URLRequest 부분 따로 구현.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToPost = Parser.encodeData(itemToPost) else {
            print("Encoding Error")
            return
        }
        ephemeralSession.uploadTask(with: urlRequest, from: dataToPost) { (data, response, error) in
            let result = Network.getResult(ItemAfterPost.self, data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
}
