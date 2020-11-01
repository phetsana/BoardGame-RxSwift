//
//  GamesListViewModelTests.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 28/10/2020.
//

import XCTest
@testable import BoardGame_RxSwift
import RxSwift
import RxTest
import RxBlocking

class GamesListViewModelTests: XCTestCase {

    var bag: DisposeBag!
    var sut: GamesListViewModel?
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        bag = DisposeBag()
        let gamesRepositoryMock = GamesRepositoryMock()
        sut = GamesListViewModel(gamesRepository: gamesRepositoryMock)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        bag = nil
        sut = nil
        scheduler = nil
        testScheduler = nil
    }
    
    func test_title() {
        let title = testScheduler.createObserver(String?.self)
        
        sut?.output
            .title
            .asObservable()
            .bind(to: title)
            .disposed(by: bag)

        XCTAssertRecordedElements(title.events, ["Board games"])
    }

    func test_games_loadingSuccess() throws {
        let games = testScheduler.createObserver([Game].self)
        let loading = testScheduler.createObserver(Bool.self)
        let error = testScheduler.createObserver(String?.self)
        
        sut?.output
            .games
            .asObservable()
            .bind(to: games)
            .disposed(by: bag)
        
        sut?.output
            .loading
            .asObservable()
            .bind(to: loading)
            .disposed(by: bag)
        
        sut?.output
            .error
            .asObservable()
            .bind(to: error)
            .disposed(by: bag)
        
        sut?.input
            .requestData
            .on(.next(()))
           
        let expectedGames = GamesRepositoryMock.gamesMock()
        XCTAssertRecordedElements(games.events, [expectedGames])
        XCTAssertRecordedElements(loading.events, [true, false])
        XCTAssertRecordedElements(error.events, [])
    }

    func test_games_loadingError() throws {
        let nsError = NSError.init(domain: "Error", code: 222, userInfo: nil)
        let gamesRepositoryMock = GamesRepositoryMock(error: nsError)
        sut = GamesListViewModel(gamesRepository: gamesRepositoryMock)
        
        let games = testScheduler.createObserver([Game].self)
        let loading = testScheduler.createObserver(Bool.self)
        let error = testScheduler.createObserver(String?.self)
        
        sut?.output
            .games
            .asObservable()
            .bind(to: games)
            .disposed(by: bag)
        
        sut?.output
            .loading
            .asObservable()
            .bind(to: loading)
            .disposed(by: bag)
        
        sut?.output
            .error
            .asObservable()
            .bind(to: error)
            .disposed(by: bag)
        
        sut?.input
            .requestData
            .on(.next(()))
           
        XCTAssertRecordedElements(games.events, [])
        XCTAssertRecordedElements(loading.events, [true, false])
        let exepectedError = "The operation couldn’t be completed. (Error error 222.)"
        XCTAssertRecordedElements(error.events, [exepectedError])
    }
}
