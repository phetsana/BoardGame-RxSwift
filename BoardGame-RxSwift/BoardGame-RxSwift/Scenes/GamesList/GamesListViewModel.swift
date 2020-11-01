//
//  GamesListViewModel.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

final class GamesListViewModel: ViewModel {
    let input: Input
    let output: Output

    struct Input {
        let requestData: AnyObserver<Void>
    }
    
    struct Output {
        let title: Driver<String?>
        let games: Driver<[Game]>
        let loading: Driver<Bool>
        let error: Driver<String?>
    }
    
    let gamesRepository: GamesRepository
    
    private let requestDataSubject = PublishSubject<Void>()
    
    init(gamesRepository: GamesRepository) {
        self.gamesRepository = gamesRepository

        let loading = PublishSubject<Bool>()
        let error = PublishSubject<String?>()
        
        let gamesObservable = gamesRepository
            .getGames()
            .map { $0 }
            .catch({ (err) -> Observable<[Game]> in
                error.on(.next(err.localizedDescription))
                loading.on(.next(false))
                return Observable.never()
            })
        
        let games = requestDataSubject
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ -> Observable<[Game]> in
                loading.on(.next(true))
                return gamesObservable
            }
            .flatMapLatest { $0 }
            .map { (games) -> [Game] in
                loading.on(.next(false))
                return games
            }
        
        let title = PublishSubject<String?>()
            .startWith("Board games")
            
        self.output = Output(title: title.asDriver(onErrorJustReturn: nil),
                             games: games.asDriver(onErrorJustReturn: []),
                             loading: loading.asDriver(onErrorJustReturn: false),
                             error: error.asDriver(onErrorJustReturn: nil))
        self.input = Input(requestData: requestDataSubject.asObserver())
    }
}
