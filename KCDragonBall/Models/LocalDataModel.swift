//
//  LocalDataModel.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 10/1/24.
//

import Foundation

struct LocalDataModel {
    private enum Constants {
        static let tokenKey = "KCToken"
    }

    private static let userDefaults = UserDefaults.standard

    static func getToken() -> String? {
        userDefaults.string(forKey: Constants.tokenKey)
    }

    static func save(token: String) {
        userDefaults.set(token, forKey: Constants.tokenKey)
    }

    static func deleteToken() {
        userDefaults.removeObject(forKey: Constants.tokenKey)
    }
}
