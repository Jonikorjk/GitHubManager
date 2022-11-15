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
    
    static func isNameFieldCorrect(_ firstNameOrLastName: String?) -> Bool {
        guard let firstNameOrLastName = firstNameOrLastName else { return false }
        return firstNameOrLastName != "" ? true : false
    }
    
    static public func checkOnRegexEmail(_ text: String?) -> Bool {
        guard let text = text else { return false }
        return text.range(of: ValidationType.email.rawValue, options: .regularExpression) != nil ? true : false
    }
    
    static public func checkOnRegexPassword(_ text: String?) -> Bool {
        guard let text = text else { return false }
        return text.range(of: ValidationType.password.rawValue, options: .regularExpression) != nil ? true : false
    }
    
//    static public func checkOnRegex(_ text: String?, type: ValidationType) -> Bool {
//        guard let text = text else { return false }
//        return text.range(of: type.rawValue, options: .regularExpression) != nil ? true : false
//    }
    
    static public func isPasswordsSimillar(_ password: String?, _ confirmPassword: String?) -> Bool {
        return (password == confirmPassword) && (password != "")
    }
    
    static public func hideOrShowErrorLabel(textField: UITextField, errorLabel: UILabel, _ validateBy: ValidationType) -> Bool {
        var functionPicker: (String?) -> Bool
        switch validateBy {
        case .email:
            functionPicker = checkOnRegexEmail
        case .password:
            functionPicker = checkOnRegexPassword
        }
        errorLabel.isHidden = functionPicker(textField.text) ? true : false
        return errorLabel.isHidden
    }
}
