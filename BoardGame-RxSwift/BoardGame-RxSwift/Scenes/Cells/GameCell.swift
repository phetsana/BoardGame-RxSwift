//
//  GameCell.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

final class GameCell: UITableViewCell {

    private(set) var sharedConstraints: [NSLayoutConstraint] = []
    
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
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .title3)
        return view
    }()

    private var bag: DisposeBag?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.imageView.image = nil
        coverImageView.cancelLoad()
        bag = nil
    }
    
    private func setupView() {
        setupUI()
        setupConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
    }
    
    private func setupUI() {
        addSubview(coverImageView)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        let marginHorizontal: CGFloat = 10
        let marginVertical: CGFloat = 5
        let spacing: CGFloat = 8

        sharedConstraints.append(contentsOf: [
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: marginVertical),
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginHorizontal),
            coverImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -marginVertical),
            coverImageView.widthAnchor.constraint(equalToConstant: 80),
            coverImageView.heightAnchor.constraint(equalToConstant: 80),
                  
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -marginHorizontal),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension GameCell {
    func bind(to viewModel: GameViewModel?) {
        let bag = DisposeBag()
        
        viewModel?.output
            .title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel?.output
            .thumbURL
            .drive(coverImageView.rx.imageURL)
            .disposed(by: bag)
        
        self.bag = bag
    }
}
