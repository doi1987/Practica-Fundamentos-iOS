//
//  String+UtilsTests.swift
//  KCDragonBallTests
//
//  Created by David Ortega Iglesias on 21/1/24.
//

import XCTest
@testable import KCDragonBall

struct Test {
    let input: String
    let output: Int?
}

final class StringUtilsTests: XCTestCase {
    private var sut: String!

    override func setUp() {
        super.setUp()
        sut = ""
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testGivenTransformationNameWhenGetTransformationNumberThenMatch() throws {
        [
            Test(input: "1. Oozaru – Gran Mono", output: 1),
            Test(input: "4. Super Saiyan", output: 4),
            Test(input: "Kaioken", output: nil)
        ].forEach { test in
            sut = test.input
            XCTAssertEqual(sut.getTransformationNumber(), test.output)

        }
    }
}
