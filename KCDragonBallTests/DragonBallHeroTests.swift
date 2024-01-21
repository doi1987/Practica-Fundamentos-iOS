//
//  DragonBallHeroTests.swift
//  KCDragonBallTests
//
//  Created by David Ortega Iglesias on 21/1/24.
//

import XCTest
@testable import KCDragonBall

final class DragonBallHeroTests: XCTestCase {
    func testGivenSameDragonBallHeroesWhenCompareThenMatch() throws {
        let firstHero: DragonBallHero = .init(photo: "test", id: "1", name: "goku", description: "me llamo goku")
        let secondHero: DragonBallHero = .init(photo: "test", id: "1", name: "goku", description: "me llamo goku")
        XCTAssertEqual(firstHero, secondHero)
    }

    func testGivenDifferentDragonBallHeroesWhenCompareThenMatch() {
        let firstHero: DragonBallHero = .init(photo: "test", id: "2", name: "vegeta", description: "me llamo vegeta")
        let secondHero: DragonBallHero = .init(photo: "test", id: "1", name: "goku", description: "me llamo goku")
        XCTAssertNotEqual(firstHero, secondHero)
    }
}
