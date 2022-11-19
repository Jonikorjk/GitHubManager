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
    
    var activeTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        Validation.toHide(errorEmailLabel, errorPasswordLabel, errorConfirmPasswordLabel)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        if let activeTextField = activeTextField {
            if activeTextField.frame.maxY > keyboardSize.minY {
//                self.view.frame.origin.y = 0 - keyboardSize.height
                self.view.frame.origin.y = 0 - (activeTextField.frame.maxY - keyboardSize.minY) - 35
            }
        }

      // move the root view up by the distance of keyboard height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
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
        
//        guard let passwordData = passwordTextField.text!.data(using: .utf8) else {
//            print("failed convert password to data")
//            return
//        }
        
        guard let loginUserDetailsVC = storyboard?.instantiateViewController(withIdentifier: "SignUpDetailsViewController") as? SignUpDetailsViewController else { return }
        loginUserDetailsVC.user = (emailTextField.text!, passwordTextField.text!)
        navigationController?.pushViewController(loginUserDetailsVC, animated: true)
        
//
//        KeyChainClass.save(passwordData, service: "usersTable", account: emailTextField.text!)
//        performSegue(withIdentifier: "toMainStoryBoardFromSignUp", sender: nil)
    }
}

extension SignUpViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}
