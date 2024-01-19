//
//  HeroTableViewCell.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 15/1/24.
//

import UIKit

final class HeroTableViewCell: UITableViewCell {

	static let identifier = "heroTableViewIdentifier"
	static let nibName = "HeroTableViewCell"

	// MARK: - Outlets
	@IBOutlet weak var heroDescription: UILabel!
	@IBOutlet weak var heroName: UILabel!
	@IBOutlet weak var chevronImage: UIImageView!
	@IBOutlet weak var heroImage: UIImageView!
	
	// MARK: - Lifecycle
	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
	}

	// MARK: - Configuration
	func configure(with hero: any DragonBallItem) {
		heroName.text = hero.name
		heroDescription.text = hero.description
		heroImage.image = UIImage(named: "placeholder")

		guard let imageURLString = hero.photo, 
				let imageURL = URL(string: imageURLString) else {
			return
		}
		heroImage.setImage(url: imageURL)
	}
}
