//
//  NetworkModel.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 9/1/24.
//

import Foundation

final class NetworkModel {
    static let shared = NetworkModel()

    private var token: String? {
        get {
            if let token = LocalDataModel.getToken() {
                return token
            }
            return nil
        }
        set {
            if let token = newValue {
                LocalDataModel.save(token: token)
            }
        }
    }

    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, DragonBallError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/auth/login"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.encodingFailed))
            return
        }
        //Encodificamos la string con un algoritmo criptografico en base 64
        let base64LoginString = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        client.jwt(urlRequest) { [weak self] result in
            switch result {
                case let .success(token):
                    self?.token = token
                    completion(.success(token))
                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }

    func getHeroes(
        completion: @escaping (Result<[DragonBallHero], DragonBallError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/all"
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        // Crear un objeto URLComponents para encodificarlo posteriormente
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Encodificamos el query item de url components
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)

        client.request(urlRequest, using: [DragonBallHero].self, completion: completion)
    }

    func getTransformations(
        completion: @escaping (Result<[HeroTransformation], DragonBallError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }

        guard let token else {
            completion(.failure(.noToken))
            return
        }

        var urlComponents = URLComponents()
        //************** Como obtener el id
        urlComponents.queryItems = [URLQueryItem(name: "id", value: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")]

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)

        client.request(urlRequest, using: [HeroTransformation].self, completion: completion)
    }
}


