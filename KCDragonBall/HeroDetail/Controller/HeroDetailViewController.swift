//
//  HeroDetailViewController.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 19/1/24.
//

import UIKit

final class HeroDetailViewController: UIViewController {

    // MARK: - Models
    private let hero: DragonBallHero
    private var heroTransformations: [HeroTransformation] = []

    // MARK: - Outlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var transformationButton: UIButton!

    // MARK: - Initializers
    init(hero: DragonBallHero) {
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getTransformations()
    }

    // MARK: - Actions
    @IBAction func didTapTransformationsButton(_ sender: Any) {
        let transformationListViewController = TransformationListTableViewController(transformations: heroTransformations)
        self.navigationController?.show(transformationListViewController, sender: nil)
    }
}

private extension HeroDetailViewController {
    func setUpView() {
        heroName.text = hero.name
        heroDescription.text = hero.description
        transformationButton.isHidden = true
        guard let imageURLString = hero.photo,
              let imageURL = URL(string: imageURLString) else {
            return
        }
        heroImage.setImage(url: imageURL)
    }

    func getTransformations() {
        NetworkModel.shared.getTransformations(heroeId: hero.id,
                                               completion: { [weak self] result in
                                                DispatchQueue.main.async {

                                                    switch result {
                                                    case var .success(transformations):
                                                        self?.transformationButton.isHidden = transformations.isEmpty
                                                        self?.heroTransformations = transformations.sorted()
                                                    case let .failure(error):
                                                        self?.transformationButton.isHidden = true
                                                        print(error)

                                                    }
                                                }
                                               }
        )

    }
}
