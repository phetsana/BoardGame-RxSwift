//
//  URLSessionClient.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class URLSessionClient {
    private let baseURL: URL?
    private let session: URLSession
    private let decoder: JSONDecoder

    init(baseURL: URL?, decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = URLSession.shared
        self.decoder = decoder
    }
}
    
// MARK: - NetworkingService
extension URLSessionClient: NetworkingService {

    func send<T: NetworkingRequest>(_ request: T) -> Observable<T.Response> {
        do {
            let url = try self.endpoint(for: request)
            let urlRequest = URLRequest(url: url)
            return session.rx
                    .data(request: urlRequest)
                    .map { try self.mapping($0, toType: request) }
        } catch {
            return Observable.create { observer in
                observer.onError(error)
                return Disposables.create {
                    
                }
            }
        }
    }
    
    private func mapping<T>(_ data: Data, toType: T) throws -> T.Response where T: NetworkingRequest {
        let mappingData = try decoder.decode(T.Response.self, from: data)
        return mappingData
    }
    
    private func endpoint<T: NetworkingRequest>(for request: T) throws -> URL {
        guard let baseURL = baseURL else {
            throw NetworkingError.endpoint
        }
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkingError.endpoint
        }
        
        urlComponents.path = request.resourceName
        
        // Custom query items needed for this specific request
        let customQueryItems: [URLQueryItem]

        do {
            customQueryItems = try URLQueryItemEncoder.encode(request)
        } catch {
            throw NetworkingError.endpoint
        }
        urlComponents.queryItems = customQueryItems
        
        guard let url = urlComponents.url else {
            throw NetworkingError.endpoint
        }
        // Construct the final URL with all the previous data
        return url
    }
}
