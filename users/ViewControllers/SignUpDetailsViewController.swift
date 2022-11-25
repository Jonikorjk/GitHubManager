//
//  SignUpDetailsViewController.swift
//  users
//
//  Created by User on 19.11.2022.
//

import UIKit
import PhotosUI

class SignUpDetailsViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var streetTextField: UITextField!
    var currentTextField: UITextField? = nil
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var errorfirstNameLabel: UILabel!
    @IBOutlet var errorlastNameLabel: UILabel!
    @IBOutlet var errorPhoneNumberLabel: UILabel!
    @IBOutlet var errorCityLabel: UILabel!
    @IBOutlet var errorStreetLabel: UILabel!
    
    @IBOutlet var birthdayDatePicker: UIDatePicker!
    
    @IBOutlet var photoImageView: UIImageView!
    var imageWasLoaded = false
    
    @IBOutlet var photoPickerButton: UIButton!
    
    @IBOutlet var additionalInfoTextView: UITextView!
    
    // data from previous VC (SignUpViewController)
    var user: (email: String, password: String)?
        
    
    private func convertImageToBase64String(image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    
    private func convertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String) else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
    
    private func formatDate(datePicker: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let date = formatter.string(from: birthdayDatePicker.date)
        return date
    }
    
    private func configuratePHPicker(selectionLimit: Int, phpFilter: [PHPickerFilter]) -> PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.selectionLimit = selectionLimit
        config.filter = .any(of: phpFilter)
        return config
    }
    
    private func configurateTextView(textView: UITextView) {
        textView.text = "Your additional info :)"
        textView.textColor = .lightGray
        textView.textAlignment = .center
    }
    
    private func setUpDelegateToSelf(textField: UITextField...) {
        for v in textField {
            v.delegate = self
        }
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any) {
        if !Validation.nameValidator(firstNameTextField) ||
            !Validation.nameValidator(lastNameTextField) ||
            !Validation.nameValidator(cityTextField) ||
            !Validation.nameValidator(streetTextField) ||
            !Validation.nameValidator(phoneTextField) {
            editingChangedFirstNameTextField("")
            editingChangedLastNameTextField("")
            editingChangedCityTextField("")
            editingChangedStreetTextField("")
            editingChangedPhoneTextField("")
            return
        }
        if !imageWasLoaded {
            let alert = UIAlertController(title: "Error!", message: "Please load your profile photo", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }

        let birthday = formatDate(datePicker: birthdayDatePicker)
        
        guard let photoInStringFormat = convertImageToBase64String(image: photoImageView.image!) else {
            print("failed to convert image to string")
            return
        }
        
        guard let email = user?.email, let password = user?.password.data(using: .utf8) else {
            print("failed to get user's email or/and password")
            return
        }
        
        let userDefaults = UserDefaults.standard
        let userData = [
            UserInfo.email.rawValue: email,
            UserInfo.birthday.rawValue: birthday,
            UserInfo.city.rawValue: cityTextField.text!,
            UserInfo.street.rawValue: streetTextField.text!,
            UserInfo.phone.rawValue: phoneTextField.text!,
            UserInfo.firstName.rawValue: firstNameTextField.text!,
            UserInfo.lastName.rawValue: lastNameTextField.text!,
            UserInfo.photoData.rawValue: photoInStringFormat,
            UserInfo.additionalInfo.rawValue: additionalInfoTextView.text!
        ]
        userDefaults.set(userData, forKey: Service.keyForUserDefaults.rawValue)
        KeyChainClass.save(password, service: Service.serviceName.rawValue, account: email)
        performSegue(withIdentifier: "toUsersTable", sender: nil)
    }
    
    @IBAction func pressedPhotoPickerButton(_ sender: Any) {
        if imageWasLoaded == false {
            let picker = PHPickerViewController(configuration: configuratePHPicker(selectionLimit: 1, phpFilter: [.images]))
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    @IBAction func editingChangedFirstNameTextField(_ sender: Any) {
        errorfirstNameLabel.isHidden = Validation.nameValidator(firstNameTextField)
    }
    
    @IBAction func editingChangedLastNameTextField(_ sender: Any) {
        errorlastNameLabel.isHidden = Validation.nameValidator(lastNameTextField)
    }
    
    @IBAction func editingChangedCityTextField(_ sender: Any) {
        errorCityLabel.isHidden = Validation.nameValidator(cityTextField)
    }
    
    @IBAction func editingChangedStreetTextField(_ sender: Any) {
        errorStreetLabel.isHidden = Validation.nameValidator(streetTextField)
    }
    
    @IBAction func editingChangedPhoneTextField(_ sender: Any) {
        errorPhoneNumberLabel.isHidden = Validation.nameValidator(phoneTextField)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if let activeTextField = currentTextField {

            if activeTextField.frame.maxY - scrollView.contentOffset.y >= keyboardSize.minY {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Validation.toHide(errorfirstNameLabel, errorlastNameLabel, errorCityLabel, errorPhoneNumberLabel, errorStreetLabel)
        birthdayDatePicker.contentHorizontalAlignment = .center
        configurateTextView(textView: additionalInfoTextView)
        setUpDelegateToSelf(textField: firstNameTextField, lastNameTextField, cityTextField, streetTextField, phoneTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension SignUpDetailsViewController: PHPickerViewControllerDelegate {
func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true, completion: nil)
    guard !results.isEmpty else {return }
        for result in results {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                 provider.loadObject(ofClass: UIImage.self) { (image, error) in
                     DispatchQueue.main.async {
                         if let image = image as? UIImage {
                              self.photoImageView.image = image
                              self.imageWasLoaded = true
                         }
                     }
                }
             }
        }
    }
}

extension SignUpDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField = nil
    }
}

extension SignUpDetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if additionalInfoTextView.text.isEmpty {
            configurateTextView(textView: additionalInfoTextView)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if additionalInfoTextView.textColor == .lightGray {
            additionalInfoTextView.textColor = .darkText
            additionalInfoTextView.textAlignment = .justified
            additionalInfoTextView.text = ""
        }
    }
}
