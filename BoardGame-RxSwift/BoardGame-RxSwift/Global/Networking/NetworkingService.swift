//
//  NetworkingService.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkingService {
    
    /// Send networking request
    func send<T: NetworkingRequest>(_ request: T) -> Observable<T.Response>
}
