//
//  LoginViewController.swift
//  users
//
//  Created by User on 15.11.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var errorEmailLabel: UILabel!
    @IBOutlet var errorPasswordLabel: UILabel!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Validation.toHide(errorEmailLabel, errorPasswordLabel)
    }
    
    @IBAction func pressedSignInButton(_ sender: Any) {
        if !Validation.hideOrShowErrorLabel(textField: emailTextField, errorLabel: errorEmailLabel, .email) ||
           !Validation.hideOrShowErrorLabel(textField: passwordTextField, errorLabel: errorPasswordLabel, .password) {
            return
        }
        
        
        guard let passwordData = KeyChainClass.read(service: "usersTable", account: emailTextField.text!) else { return }
        guard let password = String(data: passwordData, encoding: .utf8) else { return }
        if passwordTextField.text == password {
            performSegue(withIdentifier: "toMainStoryboard", sender: nil)
        }
    }
    
    @IBAction func editingChangedEmailTextField(_ sender: Any) {
        _ = Validation.hideOrShowErrorLabel(textField: emailTextField, errorLabel: errorEmailLabel, .email)
    }
    
    @IBAction func editingChangedPasswordTextField(_ sender: Any) {
        _ = Validation.hideOrShowErrorLabel(textField: passwordTextField, errorLabel: errorPasswordLabel, .password)
    }
}
