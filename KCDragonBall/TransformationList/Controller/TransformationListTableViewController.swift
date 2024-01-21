//
//  HeroListTableViewController.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 15/1/24.
//

import UIKit

final class TransformationListTableViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, DragonBallHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DragonBallHero>

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Model
    private var transformations: [HeroTransformation] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.tableView.reloadData()
            }
        }
    }

    private let networkModel = NetworkModel.shared
    private var dataSource: DataSource?

    init(transformations: [HeroTransformation]) {
        self.transformations = transformations
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
    }
}

// MARK: - Configuration
private extension TransformationListTableViewController {
    func setUpView() {
        title = "Transformations"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: TransformationTableViewCell.nibName,
                bundle: nil), forCellReuseIdentifier: TransformationTableViewCell.identifier)
        tableView.estimatedRowHeight = 112

    }
}

// MARK: - Table View Data Source
extension TransformationListTableViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return transformations.count
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TransformationTableViewCell.identifier,
            for: indexPath
        ) as? TransformationTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: transformations[indexPath.row])

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
extension TransformationListTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let transformation = transformations[indexPath.row]
        let transformationDetailViewController = TransformationDetailViewController(transformation: transformation)
        navigationController?.show(transformationDetailViewController, sender: nil)
    }
}
