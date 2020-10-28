//
//  GameDetailViewController.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 27/10/2020.
//

import UIKit

final class GameDetailViewController: UIViewController {
    
    var v = GameDetailView()
    override func loadView() { view = v }
    
    var viewModel: GameViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupBindings() {
        v.bind(to: viewModel)
    }
}

// MARK: - Builder
extension GameDetailViewController {
    static func build(viewModel: GameViewModel) -> GameDetailViewController {
        let viewController = GameDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
