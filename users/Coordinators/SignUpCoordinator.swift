//
//  SignUpCoordinator.swift
//  users
//
//  Created by User on 25.11.2022.
//

import Foundation
import UIKit

class SignUpCoordinator : Coordinator {
    var childs: [Coordinator] = []
    unowned var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let SignUpVC = SignUpViewController()
        SignUpVC.delegate = self
        navigationController.pushViewController(SignUpVC, animated: true)
    }
}

extension SignUpCoordinator: SignUpViewControllerDelegate {
    func goNext() {
        
    }
    
    func goBack() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
        navigationController.popViewController(animated: true)
    }
}

