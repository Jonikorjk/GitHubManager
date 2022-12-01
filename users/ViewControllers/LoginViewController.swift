//
//  LoginViewController.swift
//  users
//
//  Created by User on 15.11.2022.
//

import UIKit


protocol LoginViewControllerDelegate {
    func goNext() -> Void
}

class LoginViewController: UIViewController, Storyboardable {
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var errorEmailLabel: UILabel!
    @IBOutlet var errorPasswordLabel: UILabel!
    @IBOutlet var errorNoSuchUser: UILabel!
    
    var delegate: LoginViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Validation.toHide(errorEmailLabel, errorPasswordLabel, errorNoSuchUser)
    }
    
    @IBAction func pressedSignInButton(_ sender: Any) {
        if !Validation.checkOnRegex(emailTextField, type: .email) ||
            !Validation.checkOnRegex(passwordTextField, type: .password) {
            editingChangedEmailTextField(nil)
            editingChangedPasswordTextField(nil)
            return
        }
        guard let passwordData = KeyChainClass.read(service: Service.serviceName.rawValue, account: emailTextField.text!) else {
            errorNoSuchUser.isHidden = false
            return
        }
        guard let password = String(data: passwordData, encoding: .utf8) else {
            print("failed to get password data")
            return
        }
        if passwordTextField.text == password {
            performSegue(withIdentifier: "toMainStoryboard", sender: nil)
        }
        else {errorNoSuchUser.isHidden = false}
    }
    
    @IBAction func editingChangedEmailTextField(_ sender: Any?) {
        Validation.toHide(errorEmailLabel, errorPasswordLabel, errorNoSuchUser)
        errorEmailLabel.isHidden = Validation.checkOnRegex(emailTextField, type: .email)
    }
    
    @IBAction func editingChangedPasswordTextField(_ sender: Any?) {
        Validation.toHide(errorEmailLabel, errorPasswordLabel, errorNoSuchUser)
        errorPasswordLabel.isHidden = Validation.checkOnRegex(passwordTextField, type: .password)
    }
}
