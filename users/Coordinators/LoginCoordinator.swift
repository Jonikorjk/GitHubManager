//
//  Coordinators.swift
//  users
//
//  Created by User on 25.11.2022.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childs: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func goNext() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.start()
    }
}
