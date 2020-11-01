//
//  GamesRepositoryMock.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 28/10/2020.
//

@testable import BoardGame_RxSwift
import RxSwift

class GamesRepositoryMock: GamesRepository {
    
    var games: [Game] = []
    var error: Error?
    
    static func gamesMock() -> [Game] {
        let imageUrl = URL(string: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/best-board-games-adults-1585587217.jpg")
        let description = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum et convallis nisl, facilisis commodo dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam ullamcorper sem turpis, sed fermentum ligula consectetur at. Cras non odio ut est faucibus gravida sit amet vitae ipsum. Ut lobortis suscipit risus, ut iaculis ipsum gravida et. Praesent rhoncus, nisi at rutrum eleifend, nunc sapien porttitor nulla, vitae porta ante tortor id nibh. Nullam sit amet egestas leo. Nulla rutrum justo arcu, eu suscipit justo pretium eget. Proin vitae ex id nisl feugiat iaculis eu et enim. Nam interdum quam vitae lorem ultrices rhoncus. Etiam rhoncus volutpat est vitae faucibus. Curabitur et dolor mi. In pulvinar pellentesque tortor sit amet dignissim. Ut sodales tristique lorem non porttitor.
"""
        let games = [
            Game(id: "game1", name: "game 1",
                 imageUrl: imageUrl, thumbUrl: imageUrl, yearPublished: nil, minPlayers: 2, maxPlayers: 4,
                 description: description, primaryPublisher: nil, rank: 1, trendingRank: 1),
            Game(id: "game2", name: "game 2",
                 imageUrl: nil, thumbUrl: nil, yearPublished: nil, minPlayers: 2, maxPlayers: 4,
                 description: description, primaryPublisher: nil, rank: 1, trendingRank: 1)
        ]
        return games
    }
    
    init(games: [Game] = GamesRepositoryMock.gamesMock(), error: Error? = nil) {
        self.games = games
        self.error = error
    }
    
    func getGames() -> Observable<[Game]> {
        if let error = error {
            return Observable.create { (obs) -> Disposable in
                obs.onError(error)
                return Disposables.create()
            }
        }
        return Observable<[Game]>.of(games)
    }    
}
