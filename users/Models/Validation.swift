//
//  Validation.swift
//  LoginForm
//
//  Created by User on 01.11.2022.
//
import UIKit
import Foundation

class Validation {
    
    enum ValidationType: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case password  = "^.{8,}$"
    }
    
    static func toHide(_ obj: UIView...) {
        for v in obj {
            if let v = v as? UITextField {
                v.isHidden = true
            } else if let v = v as? UILabel {
                v.isHidden = true
            }
        }
    }
    
    static func toEmptyString(_ obj: UIView...) {
        for v in obj {
            if let v = v as? UITextField {
                v.text = ""
            } else if let v = v as? UILabel {
                v.text = ""
            }
        }
    }
    
    static func nameValidator(_ nameTextField: UITextField) -> Bool {
        guard let name = nameTextField.text else { return false }
        return name != "" ? true : false
    }
    
    static public func checkOnRegex(_ textField: UITextField, type: ValidationType) -> Bool {
        guard let text = textField.text else { return false }
        return text.range(of: type.rawValue, options: .regularExpression) != nil ? true : false
    }
    
    static public func isPasswordsSimillar(_ password: UITextField, _ confirmPassword: UITextField) -> Bool {
        guard let password = password.text, let confirmPassword = confirmPassword.text else { return false }
        return (password == confirmPassword) && (password != "")
    }
}
