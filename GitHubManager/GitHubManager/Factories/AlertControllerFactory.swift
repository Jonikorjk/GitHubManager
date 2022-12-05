//
//  NotificationFactory.swift
//  GitHubManager
//
//  Created by User on 05.12.2022.
//

import UIKit

class AlertControllerFactory {
    static func createNotificationAlertController(_ title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    
}
