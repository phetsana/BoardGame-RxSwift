//
//  UITableView+Binder.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 26/10/2020.
//

import RxSwift
import RxCocoa

typealias DataProvider = NSObject & UITableViewDataSource & UITableViewDelegate

extension Reactive where Base: UITableView {
    /// Bindable sink for `dataProvider` property.
    var dataProvider: Binder<DataProvider> {
        return Binder(self.base) { view, value in
            view.dataSource = value
            view.delegate = value
            view.reloadData()
        }
    }
}
