//
//  Coordinator.swift
//  users
//
//  Created by User on 25.11.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var childs: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start ()
}
