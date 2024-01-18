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
        //Codificar el expected token a data
        let tokenData = try XCTUnwrap(expectedToken.data(using: .utf8))
        //Crear usuario y contraseña mockeadas para pasarlas al metodo login
        let (user,password) = ("user", "password")
        //Nos aseguramos que el URLProtocol esta bien configurado
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { request in
            //Configuramos el login string
            let loginString = String(format: "%@:%@", user, password)
            let base64String = loginString.data(using: .utf8)!.base64EncodedString()
            //Nos aseguramos que el metodo HTTP es el correcto
            XCTAssertEqual(request.httpMethod, "POST")
            //Nos aseguramos que el header de autenticacion es el correcto
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Basic \(base64String)")
            //Creamos la respuesta mockead. Esto actua como un servidor "real" en los tests
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

        //Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedToken)
        XCTAssertEqual(receivedToken, expectedToken)
    }

    func test_getHeroes() {

    }

    func test_getTansformation() {
        
    }
}
