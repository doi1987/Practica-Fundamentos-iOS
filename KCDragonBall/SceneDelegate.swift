//
//  SceneDelegate.swift
//  KCDragonBall
//
//  Created by David Ortega Iglesias on 21/12/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        // Castear UIscene a UIWindowScene
        guard let scene = (scene as? UIWindowScene) else { return }
        // Instanciar un objeto Window con el Scene desempaquetado
        let window = UIWindow(windowScene: scene)
        // Creamnos el navigation controller
        let navigationController = UINavigationController()
        // Creamos el primer view controller de nuestra aplicacion
        let loginViewController = LoginViewController()
        // Añadimos el primer view controller al navigation controller
        navigationController.setViewControllers([loginViewController], animated: true)
        // Hacemos el navigation controller el view controller base del Window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

}

