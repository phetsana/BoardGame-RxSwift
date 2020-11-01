//
//  GameDetailView.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 27/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

final class GameDetailView: UIView {

    private(set) var sharedConstraints: [NSLayoutConstraint] = []
    
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 8
        return view
    }()

    private(set) lazy var coverImageView: RemoteImageView = {
        let view = RemoteImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        return view
    }()
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .body)
        return view
    }()

    private let bag = DisposeBag()

    convenience init() {
        self.init(frame: .zero)
        setupUI()
        setupConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        sharedConstraints.append(contentsOf: [
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            coverImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
}

extension GameDetailView {
    func bind(to viewModel: GameViewModel?) {
        viewModel?.output
            .title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.output
            .title
            .map { $0 == nil }
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: bag)
        
        viewModel?.output
            .imageURL
            .drive(coverImageView.rx.imageURL)
            .disposed(by: bag)
        
        viewModel?.output
            .imageURL
            .map { $0 == nil }
            .drive(coverImageView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel?.output
            .description
            .drive(descriptionLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.output
            .description
            .map { $0 == nil }
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: bag)
    }
}
