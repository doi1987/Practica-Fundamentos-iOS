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
    private var heroes: [DragonBallHero] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                setSnapshot()
            }
        }
    }

    private let networkModel = NetworkModel.shared
    private var dataSource: DataSource?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupDatasource()
        getHeroesList()
    }
}

// MARK: - Configuration
private extension HeroListTableViewController {
    func setUpView() {
        title = "Dragon Ball Heroes"
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: HeroTableViewCell.nibName,
                bundle: nil), forCellReuseIdentifier: HeroTableViewCell.identifier)
        tableView.estimatedRowHeight = 113

    }

    func getHeroesList() {
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

    func setupDatasource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, hero in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HeroTableViewCell.identifier,
                for: indexPath
            ) as? HeroTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: hero)
            return cell
        }
    }

    func setSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(heroes)
        dataSource?.apply(snapshot, animatingDifferences: false)
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
