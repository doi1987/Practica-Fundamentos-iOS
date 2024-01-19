//
//  DragonBallHero.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 11/1/24.
//

import Foundation
protocol DragonBallItem: Codable, Hashable {
	var photo: String? { get }
	var id: String { get }
	var name: String { get }
	var description: String { get }
}

struct DragonBallHero: DragonBallItem {
	var photo: String?
	
	var id: String
	
	var name: String
	
	var description: String
	

}
