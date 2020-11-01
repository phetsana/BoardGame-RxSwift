//
//  GamesDataProvider.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import UIKit
import RxSwift

protocol GamesDataProvider {
    var select: Observable<GameViewModel> { get }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

final class GamesDataProviderImpl: NSObject, GamesDataProvider {
 
    var select: Observable<GameViewModel> {
        return selectSubject
    }

    let gameViewModels: [GameViewModel]

    private let selectSubject = PublishSubject<GameViewModel>()
    
    init(gameViewModels: [GameViewModel]) {
        self.gameViewModels = gameViewModels
    }
}

extension GamesDataProviderImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        let gameCell = cell as? GameCell
        
        let gameViewModel = gameViewModels[indexPath.row]
        gameCell?.bind(to: gameViewModel)
  
        return cell
    }
}

extension GamesDataProviderImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameViewModel = gameViewModels[indexPath.row]
        selectSubject.on(.next((gameViewModel)))
    }
}
