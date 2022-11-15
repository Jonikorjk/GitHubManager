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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editingChangedEmailTextField(_ sender: Any?) {
        
    }
    
    @IBAction func editingChangedPasswordTextField(_ sender: Any?) {
        
    }
    
    @IBAction func editingChangerConfirmPasswordTextField(_ sender: Any?) {
        
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any?) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
