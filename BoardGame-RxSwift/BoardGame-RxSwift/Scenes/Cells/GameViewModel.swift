//
//  GameViewModel.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 26/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

final class GameViewModel: ViewModel {
    let input: Input
    let output: Output
    
    struct Input {
        let game: AnyObserver<Game>
    }
    
    struct Output {
        let title: Driver<String?>
        let imageURL: Driver<URL?>
        let thumbURL: Driver<URL?>
        let description: Driver<String?>
    }

    private let gameSubject = PublishSubject<Game>()
    
    init(game: Game) {
        let gameObs = gameSubject
            .startWith(game)

        let title = gameObs
            .map { $0.name }
            .asDriver(onErrorJustReturn: nil)
        let imageURL = gameObs
            .map { $0.imageUrl }
            .asDriver(onErrorJustReturn: nil)
        let thumbURL = gameObs
            .map { $0.thumbUrl }
            .asDriver(onErrorJustReturn: nil)
        let description = gameObs
            .map { $0.description }
            .asDriver(onErrorJustReturn: nil)
      
        self.output = Output(title: title,
                             imageURL: imageURL,
                             thumbURL: thumbURL,
                             description: description)
        self.input = Input(game: gameSubject.asObserver())
    }
}
