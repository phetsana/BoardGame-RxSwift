//
//  NetworkingServiceMock.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 01/11/2020.
//

@testable import BoardGame_RxSwift
import RxSwift

enum NetworkingServiceMockError: Error {
    case decode
}

class NetworkingServiceMock: NetworkingService {
    private let file: String
    private let type: String
    private let error: Error?
    init(file: String, type: String = "json", error: Error? = nil) {
        self.file = file
        self.type = type
        self.error = error
    }

    func data(with file: String, ofType: String = "json") -> Data? {
        let bundle = Bundle(for: Swift.type(of: self))
        if let path = bundle.path(forResource: file, ofType: ofType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }

        return nil
    }
    
    func mapData<T: Decodable>(_ data: Data, with type: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let mappingData = try decoder.decode(type, from: data)
        return mappingData
    }
    
    func send<T>(_ request: T) -> Observable<T.Response> where T : NetworkingRequest {
        let data = self.data(with: file, ofType: type)!
        if let error = error {
            return Observable<T.Response>.error(error)
        }
        do {
            if let mappingData = try self.mapData(data, with: T.Response.self) {
                return Observable<T.Response>.of(mappingData)
            } else {
                return Observable<T.Response>.error(NetworkingServiceMockError.decode)
            }
        } catch {
            return Observable<T.Response>.error(error)
        }
    }
}
