//
//  GamesRepository.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import Foundation
import RxSwift

protocol GamesRepository {
    func getGames() -> Observable<[Game]>
}

final class GamesRepositoryImpl: GamesRepository {
    
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func getGames() -> Observable<[Game]> {
        let request = GetGamesRequest()
        return networkingService.send(request)
            .map { $0.games }
    }
}
