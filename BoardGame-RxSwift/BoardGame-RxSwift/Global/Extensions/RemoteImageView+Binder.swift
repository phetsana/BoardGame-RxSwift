//
//  RemoteImageView+Binder.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 26/10/2020.
//

import RxSwift
import RxCocoa

extension Reactive where Base: RemoteImageView {
    /// Bindable sink for `imageURL` property.
    var imageURL: Binder<URL?> {
        return Binder(self.base) { view, value in
            view.load(url: value)
        }
    }
}
