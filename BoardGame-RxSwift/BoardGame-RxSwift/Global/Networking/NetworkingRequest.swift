//
//  NetworkingRequest.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import Foundation

/// API protocol request
protocol NetworkingRequest: Encodable {
    /// Response (will be wrapped with a DataContainer)
    associatedtype Response: Decodable
    
    /// Endpoint for this request (the last part of the URL)
    var resourceName: String { get }
    
    /// Parameters of request
    var parameters: [String: Any] { get }
}
