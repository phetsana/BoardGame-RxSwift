//
//  ImageCache.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import UIKit

enum ImageCacheError: Error, Equatable {
    case cancelled
    case dataConversionFailed
    case sessionError(Error)
    
    static func == (lhs: ImageCacheError, rhs: ImageCacheError) -> Bool {
        switch (lhs, rhs) {
        case (.cancelled, .cancelled):
            return true
        case (.dataConversionFailed, .dataConversionFailed):
            return true
        case (.sessionError(let lhs), .sessionError(let rhs)):
            return lhs.isEqual(to: rhs)
        default: return false
        }
    }
}

protocol ImageCache {
    func loadImage(for url: URL, completion: @escaping (Result<UIImage?, ImageCacheError>) -> Void) -> UUID?
    func cancel(for uuid: UUID)
}

class ImageCacheImpl {
    static let shared: ImageCache = ImageCacheImpl()
    
    private let urlSession: URLSession
    private let cache: NSCache<NSURL, UIImage>
    private(set) var tasksInProgress: [UUID: URLSessionDataTask]
    
    init(urlSession: URLSession = URLSession.shared,
         cache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>()) {        
        self.urlSession = urlSession
        self.cache = cache
        self.tasksInProgress = [:]
    }
}

extension ImageCacheImpl: ImageCache {
    func loadImage(for url: URL, completion: @escaping (Result<UIImage?, ImageCacheError>) -> Void) -> UUID? {
        let nsURL = url as NSURL

        if let image = cache.object(forKey: nsURL) {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = urlSession
            .dataTask(with: url) { [weak self] (data, _, error) in
                
                defer {
                    self?.tasksInProgress.removeValue(forKey: uuid)
                }
                
                if let data = data {
                    if let image = UIImage(data: data) {
                        self?.cache.setObject(image, forKey: nsURL)
                        completion(.success(image))
                    } else {
                        completion(.failure(.dataConversionFailed))
                    }
                    return
                }
                
                if let nsError = error as NSError? {
                    if nsError.code == NSURLErrorCancelled {
                        completion(.failure(.cancelled))
                    } else {
                        completion(.failure(.sessionError(nsError)))
                    }
                    return
                }
            }
        task.resume()
        
        tasksInProgress[uuid] = task
        return uuid
    }
    
    func cancel(for uuid: UUID) {
        tasksInProgress[uuid]?.cancel()
        tasksInProgress.removeValue(forKey: uuid)
    }
}

