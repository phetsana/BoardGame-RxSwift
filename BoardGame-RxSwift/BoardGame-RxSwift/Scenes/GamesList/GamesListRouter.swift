//
//  GamesListRouter.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 27/10/2020.
//

import UIKit
import RxSwift

protocol GamesListRouter {
    func routeToDetail(viewModel: GameViewModel)
}

final class GamesListRouterImpl: NSObject {
    weak var viewController: GamesListViewController?
}

// MARK: - GamesListRouter
extension GamesListRouterImpl: GamesListRouter {
    func routeToDetail(viewModel: GameViewModel) {
        let gameDetailViewController = GameDetailViewController.build(viewModel: viewModel)
        viewController?.navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
}
