//
//  NetworkModelTests.swift
//  KCDragonBallTests
//
//  Created by David Ortega Iglesias on 11/1/24.
//

import XCTest
@testable import KCDragonBall

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModel!
    private var expectedToken = "token"

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let client = APIClient(session: session)
        sut = NetworkModel(client: client)
        expectedToken = "token"
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        expectedToken = ""
    }

    func test_login() throws {
        // Given
        // Codificar el expected token a data
        let tokenData = try XCTUnwrap(expectedToken.data(using: .utf8))
        // Crear usuario y contraseña mockeadas para pasarlas al metodo login
        let (user, password) = ("user", "password")
        // Nos aseguramos que el URLProtocol esta bien configurado
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            // Configuramos el login string
            let loginString = String(format: "%@:%@", user, password)
            let base64String = loginString.data(using: .utf8)!.base64EncodedString()
            // Nos aseguramos que el metodo HTTP es el correcto
            XCTAssertEqual(request.httpMethod, "POST")
            // Nos aseguramos que el header de autenticacion es el correcto
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Basic \(base64String)")
            // Creamos la respuesta mockead. Esto actua como un servidor "real" en los tests
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education/")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, tokenData)
        }

        // When
        let expectation = expectation(description: "Login success")
        var receivedToken: String?
        sut.login(
            user: user,
            password: password
        ) { result in
            guard case let .success(token) = result else {
                XCTFail("Expected succes but received \(result)")
                return
            }
            receivedToken = token
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedToken)
        XCTAssertEqual(receivedToken, expectedToken)
    }

    func testGivenHeroesWhenGetHeroesListThenMatchSuccess() throws {
        // Given
        let goku = DragonBallHero(photo: "test", id: "1", name: "goku", description: "me llamo goku")
        let vegeta = DragonBallHero(photo: "test", id: "2", name: "vegeta", description: "me llamo vegeta")

        let expectedHeroes = [goku, vegeta]

        let heroesData = try XCTUnwrap(JSONEncoder().encode(expectedHeroes))

        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")

            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education/")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, heroesData)
        }

        // When
        let expectation = expectation(description: "Get Heroes success")
        var heroesResult: [DragonBallHero]?

        sut.getHeroes { result in
            guard case let .success(heroes) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            heroesResult = heroes
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(heroesResult)
        XCTAssertEqual(heroesResult, expectedHeroes)
    }

    func testGivenNoDataWhenGetHeroesListThenMatchError() throws {
        // Given

        MockURLProtocol.error = DragonBallError.noData
        MockURLProtocol.requestHandler = nil

        // When
        let expectation = expectation(description: "Get Error")
        var errorResult: DragonBallError?

        sut.getHeroes { result in
            guard case let .failure(error) = result else {
                XCTFail("Expected failure but received \(result)")
                return
            }
            errorResult = error
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(errorResult)
        XCTAssertEqual(errorResult, .noData)
    }

    func testGivenTransformationWhenGetTransformationListThenMatchSuccess() throws {
        // Given
        let kaioKen = HeroTransformation(id: "1", photo: "test", description: "entrenamiento", name: "KaioKen")
        let ozaru = HeroTransformation(id: "2", photo: "test", description: "mono", name: "Ozaru")

        let expectedTransformations = [kaioKen, ozaru]

        let transformationData = try XCTUnwrap(JSONEncoder().encode(expectedTransformations))

        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")

            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education/")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, transformationData)
        }

        // When
        let expectation = expectation(description: "Get Transformation success")
        var transformationResult: [HeroTransformation]?

        sut.getTransformations(heroeId: "1") { result in
            guard case let .success(tranformations) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            transformationResult = tranformations
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(transformationResult)
        XCTAssertEqual(transformationResult, expectedTransformations)
    }

    func testGivenStatusCode500WhenGetTransformationListThenMatchError() throws {
        // Given
        let dragonBallError = DragonBallError.statusCode(code: 500)
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education/")!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, Data())
        }

        // When
        let expectation = expectation(description: "Get Error")
        var errorResult: DragonBallError?

        sut.getTransformations(heroeId: "1") { result in
            guard case let .failure(error) = result else {
                XCTFail("Expected failure but received \(result)")
                return
            }
            errorResult = error
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertNotNil(errorResult)
        XCTAssertEqual(errorResult, dragonBallError)
    }
}
