//
//  GameAtlasNetworkingService.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import Foundation

struct GameAtlasConstants {
    static let baseURL = Environment.current.baseURL
    static let clientID = Environment.current.clientID
}

final class GameAtlasNetworkingService: URLSessionClient {
    static let shared = GameAtlasNetworkingService()
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        super.init(baseURL: GameAtlasConstants.baseURL, decoder: decoder)
    }
    
    override func endpoint<T: NetworkingRequest>(for request: T) throws -> URL {
        return try super.endpoint(for: request).addClientID()
    }
}

fileprivate extension URL {
    func addClientID() -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: "client_id", value: GameAtlasConstants.clientID)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
