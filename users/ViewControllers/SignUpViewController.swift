//
//  SignUpViewController.swift
//  users
//
//  Created by User on 16.11.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var errorEmailLabel: UILabel!
    @IBOutlet var errorPasswordLabel: UILabel!
    @IBOutlet var errorConfirmPasswordLabel: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Validation.toHide(errorEmailLabel, errorPasswordLabel, errorConfirmPasswordLabel)
    }
    
    @IBAction func editingChangedEmailTextField(_ sender: Any?) {
        _ = Validation.hideOrShowErrorLabel(textField: emailTextField, errorLabel: errorEmailLabel, .email)
    }
    
    @IBAction func editingChangedPasswordTextField(_ sender: Any?) {
        _ = Validation.hideOrShowErrorLabel(textField: passwordTextField, errorLabel: errorPasswordLabel, .password)
    }
    
    @IBAction func editingChangerConfirmPasswordTextField(_ sender: Any?) {
        _ = Validation.isPasswordsSimillar(passwordTextField, confirmPasswordTextField, errorConfirmPasswordLabel)
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any?) {
        if Validation.hideOrShowErrorLabel(textField: emailTextField, errorLabel: errorEmailLabel, .email)          ||
           Validation.hideOrShowErrorLabel(textField: passwordTextField, errorLabel: errorPasswordLabel, .password) ||
           Validation.isPasswordsSimillar(passwordTextField, confirmPasswordTextField, errorConfirmPasswordLabel) {
            
            guard let passwordData = passwordTextField.text!.data(using: .utf8) else {
                print("failed convert password to data")
                return
            }
            
            KeyChainClass.save(passwordData, service: "usersTable", account: emailTextField.text!)
            performSegue(withIdentifier: "toMainStoryBoardFromSignUp", sender: nil)
        }
    }
}
