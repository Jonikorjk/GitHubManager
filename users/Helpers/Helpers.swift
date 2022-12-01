//
//  Helpers.swift
//  users
//
//  Created by User on 01.12.2022.
//

import UIKit

extension UIViewController {
    func setUpDelegateToSelf(textFields: UITextField...) {
        for v in textFields {
            v.delegate = self as? UITextFieldDelegate
        }
    }
}


// When current viewController conforms UITextFieldDelegate. In case when viewController does not conform UI

