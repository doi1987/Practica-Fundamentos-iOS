//
//  LoginViewController.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 21/12/23.
//

import UIKit

final class LoginViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Model
    private let model = NetworkModel.shared
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions

    @IBAction func buttonTouchCancel(_ sender: Any) {
        zoomOut()
    }
    @IBAction func buttonTouchDown(_ sender: Any) {
        zoomIn()
    }
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        zoomOut()
        model.login(
            user: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { [weak self] result in
//            guard let self else { return }
            switch result {
                case let .success(token):
                //*******   Navegar al viewcontroller de heroes
                DispatchQueue.main.async {
                    let heroesListViewController = UIViewController()
                    self?.navigationController?.setViewControllers([heroesListViewController], animated: true)
                }
                case let .failure(error):
                //*********
                    print("🔴 \(error)")
            }
        }
//NO DEBE IR EN EL LOGIN
        model.getHeroes { result in
            switch result {
                case let .success(heroes):
                    print("🟢 \(heroes)")
                case let .failure(error):
                    print("⚠️ \(error)")
            }
        }

        model.getTransformations { result in
            switch result {
                case let .success(transformation):
                    print("🟢 \(transformation)")
                case let .failure(error):
                    print("⚠️ \(error)")
            }
        }
    }
}

// MARK: - Animations

extension LoginViewController {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.continueButton.transform = .identity
                .scaledBy(x: 0.94, y: 0.94)
            }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.continueButton.transform = .identity
            }
    }
}
