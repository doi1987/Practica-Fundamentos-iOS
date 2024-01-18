//
//  APIClient.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 9/1/24.
//

import Foundation

// MARK: - Custom Error
enum DragonBallError: Error {
    case malformedURL
    case noData
    case statusCode(code: Int?)
    case decodingFailed
    case encodingFailed
    case noToken
    case unknown
}

extension DragonBallError {
    static func error(for code: Int) -> DragonBallError? {
        switch code {
        case 0: return .statusCode(code: nil)
        case 1: return .malformedURL
        case 2: return .noData
        case 3: return .statusCode(code: 400)
        case 4: return .decodingFailed
        case 5: return .encodingFailed
        case 6: return .noToken
        case 7: return .unknown
        default: return nil
        }
    }
}

// MARK: - API Client

protocol APIClientProtocol {
    var session: URLSession { get }
    func request<T: Decodable>(
        _ request: URLRequest,
        using type: T.Type,
        completion: @escaping (Result<T, DragonBallError>) -> Void
    )

    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, DragonBallError>) -> Void
    )
}

struct APIClient: APIClientProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        _ request: URLRequest,
        using type: T.Type,
        completion: @escaping (Result<T, DragonBallError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            let result: Result<T, DragonBallError>

            defer {
                completion(result)
            }

            guard error == nil else {
                if let error = error as? NSError,
                   let error = DragonBallError.error(for: error.code) {
                    result = .failure(error)
                } else {
                    result = .failure(.unknown)
                }
                return
            }

            guard let data else {
                result = .failure(.noData)
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode

            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }

            guard let resource = try? JSONDecoder().decode(type, from: data) else {
                result = .failure(.decodingFailed)
                return
            }

            result = .success(resource)
        }
        .resume()
    }

    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, DragonBallError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            let result: Result<String, DragonBallError>

            defer {
                completion(result)
            }

            guard error == nil else {
                if let error = error as? NSError,
                   let error = DragonBallError.error(for: error.code) {
                    result = .failure(error)
                } else {
                    result = .failure(.unknown)
                }
                return
            }

            guard let data else {
                result = .failure(.noData)
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode

            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }

            guard let jwt = String(data: data, encoding: .utf8) else {
                result = .failure(.decodingFailed)
                return
            }

            result = .success(jwt)
        }
        .resume()
    }
}
