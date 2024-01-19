//
//  HeroTableViewCell.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 15/1/24.
//

import UIKit

final class TransformationTableViewCell: UITableViewCell {

	static let identifier = "TransformationTableViewCellIdentifier"
	static let nibName = "TransformationTableViewCell"

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
	func configure(with transformation: HeroTransformation) {
		heroName.text = transformation.name
		heroDescription.text = transformation.description
		heroImage.image = UIImage(named: "placeholder")

		guard let imageURLString = transformation.photo,
				let imageURL = URL(string: imageURLString) else {
			return
		}
		heroImage.setImage(url: imageURL)
	}
}
