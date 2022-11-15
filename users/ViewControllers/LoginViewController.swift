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
    
    var profile: Dictionary<String,String> = UserDefaults.standard.dictionary(forKey: "userProfile") as! Dictionary<String,String>
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Validation.toHide(errorEmailLabel, errorPasswordLabel)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func pressedSignInButton(_ sender: Any) {
//        if !Validation.hideOrShowErrorLabel(textField: emailTextField, errorLabel: errorEmailLabel, .email) ||
//            !Validation.hideOrShowErrorLabel(textField: passwordTextField, errorLabel: errorPasswordLabel, .password) {
//            return
//        }
        
        
        guard let passwordData = KeyChainClass.read(service: "usersManager", account: profile["login"]!) else { return }
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
