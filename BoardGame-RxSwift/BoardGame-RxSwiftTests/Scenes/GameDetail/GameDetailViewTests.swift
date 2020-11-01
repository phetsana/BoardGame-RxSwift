//
//  GameDetailViewTests.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 01/11/2020.
//

import XCTest
@testable import BoardGame_RxSwift
import RxSwift
import RxTest
import RxBlocking

class GameDetailViewTests: XCTestCase {

    var bag: DisposeBag!
    var sut: GameDetailView?
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        bag = DisposeBag()
        
        sut = GameDetailView()

        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        bag = nil
        sut = nil
        scheduler = nil
        testScheduler = nil
    }
    
    func test_init() {
        XCTAssertNotNil(sut?.scrollView)
        XCTAssertNotNil(sut?.stackView)
        XCTAssertNotNil(sut?.titleLabel)
        XCTAssertNotNil(sut?.coverImageView)
        XCTAssertNotNil(sut?.descriptionLabel)
    }
    
    func test_binding() {
        XCTAssertEqual(sut?.titleLabel.text, nil)
        XCTAssertEqual(sut?.coverImageView.imageView.image, nil)
        XCTAssertEqual(sut?.descriptionLabel.text, nil)
        
        let game = Game(id: "id game", name: "name game", imageUrl: URL(string: "https://urlgame.fr"), thumbUrl: URL(string: "https://urlgamethumb.fr"), yearPublished: 2000, minPlayers: 2, maxPlayers: 4, description: "Description game", primaryPublisher: "Publisher gme", rank: 2, trendingRank: 3)
        let viewModel = GameViewModel(game: game)
        sut?.bind(to: viewModel)
        
        XCTAssertEqual(sut?.titleLabel.text, "name game")
        XCTAssertEqual(sut?.coverImageView.imageView.image, nil)
        XCTAssertEqual(sut?.descriptionLabel.text, "Description game")
    }
}

