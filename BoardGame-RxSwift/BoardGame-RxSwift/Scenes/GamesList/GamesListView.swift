//
//  GamesListView.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

final class GamesListView: UIView {

    private(set) var sharedConstraints: [NSLayoutConstraint] = []
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableFooterView = UIView()
        return view
    }()
    
    private(set) lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private(set) lazy var loaderActivyIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .medium
        return view
    }()

    private let bag = DisposeBag()
    private var dataProvider: DataProvider?
    private var selectItemSubject = PublishSubject<GameViewModel>()
    var selectItem: Observable<GameViewModel> {
        selectItemSubject
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupUI()
        setupConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(loaderActivyIndicatorView)
        addSubview(tableView)
        addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        sharedConstraints.append(contentsOf: [
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            loaderActivyIndicatorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loaderActivyIndicatorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension GamesListView {
    func bind(to viewModel: GamesListViewModel?) {        
        viewModel?.output
            .loading            
            .drive(loaderActivyIndicatorView.rx.isAnimating,
                  tableView.rx.isHidden,
                  errorLabel.rx.isHidden)
            .disposed(by: bag)
        
        viewModel?.output
            .error
            .drive(errorLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.output
            .error
            .map { $0 == nil }
            .drive(tableView.rx.isHidden)
            .disposed(by: bag)

        let dataProvider = viewModel?.output
            .gameViewModels
            .map({ [weak self] (gameViewModels) -> DataProvider in
                let dataProvider = GamesDataProviderImpl(gameViewModels: gameViewModels)
                self?.dataProvider = dataProvider
                return dataProvider
            })

        dataProvider?
            .drive(tableView.rx.dataProvider)
            .disposed(by: bag)

        dataProvider?
            .asObservable()
            .compactMap { $0 as? GamesDataProvider }
            .flatMap { $0.select }
            .bind(to: selectItemSubject)
            .disposed(by: bag)
    }
}
