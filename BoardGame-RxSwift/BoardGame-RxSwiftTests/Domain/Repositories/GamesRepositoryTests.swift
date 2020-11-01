//
//  GamesRepositoryTests.swift
//  BoardGame-RxSwiftTests
//
//  Created by Phetsana PHOMMARINH on 01/11/2020.
//

import XCTest
@testable import BoardGame_RxSwift
import RxSwift
import RxTest
import RxBlocking

class GamesRepositoryTests: XCTestCase {

    var bag: DisposeBag!
    var sut: GamesRepository?
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        bag = DisposeBag()
        let networkingServiceMock = NetworkingServiceMock(file: "search")
        sut = GamesRepositoryImpl(networkingService: networkingServiceMock)

        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        bag = nil
        sut = nil
        scheduler = nil
        testScheduler = nil
    }
    
    func test_getGames_success() {       
        let games = testScheduler.createObserver([Game].self)
       
        sut?.getGames()
            .bind(to: games)
            .disposed(by: bag)

        let netorkingServiceMock = NetworkingServiceMock(file: "search")

        let expectedGames = netorkingServiceMock
            .data(with: "search")
            .map({ (data) -> Games in
                if let decodable = try? netorkingServiceMock.mapData(data, with: Games.self) {
                    return decodable
                } else {
                    fatalError("error decode")
                }
            })
            .map { $0.games }!
                
        
        let expectedEvents = Recorded.events(
            .next(0, expectedGames),
            .completed(0)
        )

        XCTAssertEqual(games.events, expectedEvents)
    }
    
    func test_getGames_error() {
        let games = testScheduler.createObserver([Game].self)
       
        let nsError = NSError(domain: "error 44", code: 44, userInfo: nil)
        let networkingServiceMock = NetworkingServiceMock(file: "search", error: nsError)
        sut = GamesRepositoryImpl(networkingService: networkingServiceMock)
        
        sut?.getGames()
            .bind(to: games)
            .disposed(by: bag)
        
        let expectedEvents: [Recorded<Event<[Game]>>] = Recorded.events(
            .error(0, nsError)
        )
        
        XCTAssertEqual(games.events, expectedEvents)
    }
}

