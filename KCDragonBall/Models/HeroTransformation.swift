//
//  HeroTransformation.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 11/1/24.
//

import Foundation

struct HeroTransformation: Codable, Hashable {
    let id: String
    let photo: String?
    let description: String
    let name: String
}

extension HeroTransformation: Comparable {
    static func < (lhs: HeroTransformation, rhs: HeroTransformation) -> Bool {
        guard let lhsNumber = lhs.name.getTransformationNumber(),
              let rhsNumber = rhs.name.getTransformationNumber() else {
            return lhs.name < rhs.name
        }

        return lhsNumber < rhsNumber
    }
}
