//
//  HeroListTableViewController.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 15/1/24.
//

import UIKit

final class HeroListTableViewController: UITableViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, DragonBallHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DragonBallHero>

    // MARK: - Model
    //**************** ini a vacio
    private let heroes: [DragonBallHero] = []
    private let networkModel = NetworkModel.shared
    private var dataSource: DataSource?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
//****** clase 6 min 12
        networkModel.getHeroes { result in
            switch result {
                case let .success(heroes):
                    print(heroes)
                case let .failure(error):
                    print(error)
            }
        }
    }
}
    // MARK: - Configuration
private extension HeroListTableViewController {
    func setUpView() {
        title = "Dragon Ball Heroes"
    }
}

    // MARK: - Table View Data Source
extension HeroListTableViewController {
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        //******* coger el numero d heroes
        return 6
    }
}

    //MARK: - TableView Delegate
extension HeroListTableViewController {
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
    // ***************
        let dragonBallHero = indexPath
        var content = cell.defaultContentConfiguration()
//************** coger el texto d heroes
        content.text = "Hola"
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("ñaa \(indexPath.row)")
    }
}
