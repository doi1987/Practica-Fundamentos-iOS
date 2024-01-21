//
//  TransformationDetailViewController.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 20/1/24.
//

import UIKit

final class TransformationDetailViewController: UIViewController {
    // MARK: - Models
    private let transformation: HeroTransformation

    // MARK: - Initializers
    init(transformation: HeroTransformation) {
        self.transformation = transformation
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Outlets

    @IBOutlet weak var transformationImage: UIImageView!
    @IBOutlet weak var transformationName: UILabel!
    @IBOutlet weak var transformationDescription: UILabel!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}
// MARK: - View Configuration
private extension TransformationDetailViewController {
    func setUpView() {
        transformationName.text = transformation.name
        transformationDescription.text = transformation.description
        guard let imageURLString = transformation.photo,
              let imageURL = URL(string: imageURLString) else {
            return
        }
        transformationImage.setImage(url: imageURL)
    }
}
