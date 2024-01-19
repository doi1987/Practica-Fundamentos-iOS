//
//  HeroListTableViewController.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 15/1/24.
//

import UIKit

final class HeroListTableViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, DragonBallHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DragonBallHero>

	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Model
	private var heroes: [any DragonBallItem] {
		didSet {
			DispatchQueue.main.async { [weak self] in
				guard let self else { return }

				self.tableView.reloadData()
			}
		}
	}
    private let networkModel = NetworkModel.shared
    private var dataSource: DataSource?

	init(heroes: [any DragonBallItem] = []) {
		self.heroes = heroes
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    // MARK: - View Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
		guard heroes.isEmpty else {
			return
		}

		getHeroesList()
    }
}

// MARK: - Configuration
private extension HeroListTableViewController {
	func setUpView() {
		title = "Dragon Ball Heroes"
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(
			UINib(
				nibName: HeroTableViewCell.nibName,
				bundle: nil), forCellReuseIdentifier: HeroTableViewCell.identifier)
		tableView.estimatedRowHeight = 112

	}

	func getHeroesList() {
		// ***** calse 6 min 29
		//		let registration = UITableView
		networkModel.getHeroes { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(heroes):
				self.heroes = heroes
			case let .failure(error):
				print(error)
			}
		}
	}
}

	// MARK: - Table View Data Source
extension HeroListTableViewController: UITableViewDataSource {
	func numberOfSections(
		in tableView: UITableView
	) -> Int {
		return 1
	}

	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		return heroes.count
	}
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: HeroTableViewCell.identifier,
			for: indexPath) as? HeroTableViewCell else {
			return UITableViewCell()
		}

		cell.configure(with: heroes[indexPath.row])

		return cell

//		let cell = UITableViewCell()
//		// ***************
//		let dragonBallHero = heroes[indexPath.row]
//		var content = cell.defaultContentConfiguration()
//		// ************** coger el texto d heroes
//		content.text = dragonBallHero.name
//		cell.contentConfiguration = content
//		return cell
	}
}

// MARK: - TableView Delegate
extension HeroListTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
		let hero = heroes[indexPath.row]

		let heroDetailViewController = HeroDetailViewController(hero: hero)
		navigationController?.show(heroDetailViewController, sender: nil)
    }
}
