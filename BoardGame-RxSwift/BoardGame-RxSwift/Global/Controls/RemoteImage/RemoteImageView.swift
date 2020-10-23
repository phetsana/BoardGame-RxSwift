//
//  RemoteImageView.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import UIKit

private enum RemoteImageViewState {
    case loading
    case loaded(UIImage?)
    case cancelled
    case error
}

class RemoteImageView: UIView {
    
    private(set) lazy var imageView: UIImageView = {
        let remoteImageView = UIImageView()
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        remoteImageView.contentMode = .scaleAspectFill
        remoteImageView.clipsToBounds = true
        remoteImageView.tintColor = .black
        return remoteImageView
    }()
    
    private(set) lazy var loaderActivyIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .gray
        return activityIndicatorView
    }()

    private(set) var sharedConstraints: [NSLayoutConstraint] = []
    
    private var notFoundImage: UIImage?
    
    convenience init(notFoundImage: UIImage? = nil) {
        self.init(frame: .zero)
        self.notFoundImage = notFoundImage
        setupUI()
        setupConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(loaderActivyIndicatorView)
    }
    
    private func setupConstraints() {
        sharedConstraints.append(contentsOf: [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
 
            loaderActivyIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loaderActivyIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func updateImage(with state: RemoteImageViewState) {
        switch state {
        case .loading:
            imageView.image = nil
            imageView.isHidden = true
            loaderActivyIndicatorView.isHidden = false
            loaderActivyIndicatorView.startAnimating()
        case .loaded(let image):
            imageView.image = image
            imageView.isHidden = false
            loaderActivyIndicatorView.isHidden = true
            loaderActivyIndicatorView.stopAnimating()
        case .cancelled:
            imageView.image = nil
            imageView.isHidden = true
            loaderActivyIndicatorView.isHidden = true
            loaderActivyIndicatorView.stopAnimating()
        case .error:
            imageView.image = notFoundImage
            imageView.isHidden = false
            loaderActivyIndicatorView.isHidden = true
            loaderActivyIndicatorView.stopAnimating()
        }
    }
}

extension RemoteImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        
        updateImage(with: .loading)
        ImageLoader.loader.load(url, for: imageView) { [weak self] (result) in
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    self?.updateImage(with: .loaded(image))
                }
            } catch let error {
                DispatchQueue.main.async {
                    if let error = error as? ImageCacheError,
                       error == .cancelled {
                        self?.updateImage(with: .cancelled)
                    } else {
                        self?.updateImage(with: .error)
                    }
                }
            }
        }
    }
    
    func cancelLoad() {
        ImageLoader.loader.cancel(for: imageView)
    }
}
