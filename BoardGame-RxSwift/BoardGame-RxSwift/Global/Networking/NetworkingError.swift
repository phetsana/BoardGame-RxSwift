//
//  NetworkingError.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import Foundation

/// API errors
enum NetworkingError: Error {
    case encoding
    case decoding
    case endpoint
    case other(Error)
}
