//
//  SignUpViewController.swift
//  users
//
//  Created by User on 16.11.2022.
//

import UIKit

protocol SignUpViewControllerDelegate {
    func goNext()
    func goBack()
}

class SignUpViewController: UIViewController {
    
    var delegate: SignUpViewControllerDelegate!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var errorEmailLabel: UILabel!
    @IBOutlet var errorPasswordLabel: UILabel!
    @IBOutlet var errorConfirmPasswordLabel: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    var activeTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegateToSelf(textFields: emailTextField, passwordTextField, confirmPasswordTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        Validation.toHide(errorEmailLabel, errorPasswordLabel, errorConfirmPasswordLabel)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if let activeTextField = activeTextField {
            if activeTextField.frame.maxY > keyboardSize.minY {
                self.view.frame.origin.y = 0 - (activeTextField.frame.maxY - keyboardSize.minY) - 35
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
    
    @IBAction func editingChangedEmailTextField(_ sender: Any?) {
        errorEmailLabel.isHidden = Validation.checkOnRegex(emailTextField, type: .email)
    }
    
    @IBAction func editingChangedPasswordTextField(_ sender: Any?) {
        errorPasswordLabel.isHidden = Validation.checkOnRegex(passwordTextField, type: .password)
    }
    
    @IBAction func editingChangerConfirmPasswordTextField(_ sender: Any?) {
        errorConfirmPasswordLabel.isHidden = Validation.isPasswordsSimillar(passwordTextField, confirmPasswordTextField)
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any?) {
        if !Validation.checkOnRegex(emailTextField, type: .email)       ||
           !Validation.checkOnRegex(passwordTextField, type: .password) ||
           !Validation.isPasswordsSimillar(passwordTextField, confirmPasswordTextField) {
            editingChangedEmailTextField(nil)
            editingChangedPasswordTextField(nil)
            editingChangerConfirmPasswordTextField(nil)
            return
        }
        let signUpDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpDetailsViewController") as! SignUpDetailsViewController
        signUpDetailsViewController.user = (emailTextField.text!, passwordTextField.text!) // force unwraped because text was validated upper
        navigationController?.pushViewController(signUpDetailsViewController, animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
