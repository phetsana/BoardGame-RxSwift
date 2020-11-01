//
//  GameDataProviderTests.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 01/11/2020.
//

import XCTest
@testable import BoardGame_RxSwift
import RxSwift
import RxTest
import RxBlocking

class GameDataProviderTests: XCTestCase {

    var sut: GamesDataProvider?
    var tableView: UITableView!
    var bag: DisposeBag!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        let games = GamesRepositoryMock.gamesMock()
        let gameViewModels = games.compactMap { GameViewModel(game: $0) }
        sut = GamesDataProviderImpl(gameViewModels: gameViewModels)
        tableView = UITableView()
        tableView.register(GameCell.self, forCellReuseIdentifier: "GameCell")
        bag = DisposeBag()       
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        sut = nil
        tableView = nil
        bag = nil
        scheduler = nil
        testScheduler = nil
    }

    func test_numberOfRowsInSection() {
        let numberOfRowsInSection = sut?.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRowsInSection, 2)
    }
    
    func test_cell() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut?.tableView(tableView, cellForRowAt: indexPath)
        let gameCell = cell as? GameCell
        
        XCTAssertNotNil(gameCell)
        
        XCTAssertEqual(gameCell?.titleLabel.text, "game 1")
        XCTAssertNil(gameCell?.imageView?.image)
    }
    
    func test_select() {
        let select = testScheduler.createObserver(GameViewModel.self)

        sut?.select
            .bind(to: select)
            .disposed(by: bag)
                                
        XCTAssertEqual(select.events.count, 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        sut?.tableView(tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(select.events.count, 1)
    }
    
}
