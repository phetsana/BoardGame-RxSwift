//
//  GamesListViewController.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

struct CellRegister {
    let classType: AnyClass
    let reuseIdentifier: String
}

final class GamesListViewController: UIViewController {
    
    var v = GamesListView()
    override func loadView() { view = v }
    
    var viewModel: GamesListViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    var router: GamesListRouter?

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        requestData()
    }
    
    private func setupView() {
        v.tableView.register(GameCell.self, forCellReuseIdentifier: "GameCell")
                
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(requestData))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc private func requestData() {
        viewModel?.input.requestData.on(.next(()))
    }
        
    private func setupBindings() {
        viewModel?.output
            .title
            .drive(rx.title)
            .disposed(by: bag)

        v.selectItem
            .subscribe { [weak self] (viewModel) in
                self?.router?.routeToDetail(viewModel: viewModel)
            }
            .disposed(by: bag)

        v.bind(to: viewModel)
    }
}

// MARK: - Builder
extension GamesListViewController {
    static func build() -> GamesListViewController {
        let networkingService = GameAtlasNetworkingService.shared
        let gamesRepository = GamesRepositoryImpl(networkingService: networkingService)
        let viewModel = GamesListViewModel(gamesRepository: gamesRepository)
        let viewController = GamesListViewController()
        viewController.viewModel = viewModel
        let router = GamesListRouterImpl()
        router.viewController = viewController
        viewController.router = router
        return viewController
    }
}
