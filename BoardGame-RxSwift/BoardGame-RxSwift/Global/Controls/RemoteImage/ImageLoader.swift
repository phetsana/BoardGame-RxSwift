//
//  UIImageLoader.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import UIKit

class ImageLoader {
    static let loader = ImageLoader()

    private let imageCache: ImageCache
    private var uuidMap = [UIImageView: UUID]()

    init(imageCache: ImageCache = ImageCacheImpl.shared) {
        self.imageCache = imageCache
    }

    func load(_ url: URL, for imageView: UIImageView, completion: @escaping (Result<UIImage?, ImageCacheError>) -> Void) {
        let token = imageCache.loadImage(for: url) { [weak self] (result) in
            defer { self?.uuidMap.removeValue(forKey: imageView) }
            completion(result)
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
      
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageCache.cancel(for: uuid)
            uuidMap.removeValue(forKey: imageView)
        }
      }
}
