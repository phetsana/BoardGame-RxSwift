//
//  GameViewModelTests.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 31/10/2020.
//

import XCTest
@testable import BoardGame_RxSwift
import RxSwift
import RxTest
import RxBlocking

class GameViewModelTests: XCTestCase {

    var bag: DisposeBag!
    var sut: GameViewModel?
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        bag = DisposeBag()
        let game = Game(id: "id game", name: "name game", imageUrl: URL(string: "https://urlgame.fr"), thumbUrl: URL(string: "https://urlgamethumb.fr"), yearPublished: 2000, minPlayers: 2, maxPlayers: 4, description: "Description game", primaryPublisher: "Publisher gme", rank: 2, trendingRank: 3)
        sut = GameViewModel(game: game)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        bag = nil
        sut = nil
        scheduler = nil
        testScheduler = nil
    }

    func test_games_loadingSuccess() throws {
        let title = testScheduler.createObserver(String?.self)
        let imageURL = testScheduler.createObserver(URL?.self)
        let thumbURL = testScheduler.createObserver(URL?.self)
        let description = testScheduler.createObserver(String?.self)
        
        sut?.output
            .title
            .asObservable()
            .bind(to: title)
            .disposed(by: bag)
        
        sut?.output
            .imageURL
            .asObservable()
            .bind(to: imageURL)
            .disposed(by: bag)
        
        sut?.output
            .thumbURL
            .asObservable()
            .bind(to: thumbURL)
            .disposed(by: bag)
        
        sut?.output
            .description
            .asObservable()
            .bind(to: description)
            .disposed(by: bag)

        XCTAssertRecordedElements(title.events, ["name game"])
        XCTAssertRecordedElements(imageURL.events, [URL(string: "https://urlgame.fr")])
        XCTAssertRecordedElements(thumbURL.events, [URL(string: "https://urlgamethumb.fr")])
        XCTAssertRecordedElements(description.events, ["Description game"])
    }
}

