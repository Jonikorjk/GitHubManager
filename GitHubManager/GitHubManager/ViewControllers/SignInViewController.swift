//
//  ViewController.swift
//  GitHubManager
//
//  Created by User on 05.12.2022.
//

import SnapKit
import Moya

class SignInViewController: UIViewController {
    lazy var logoImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "github")
        return imageView
    }()
    
    lazy var tokenTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Input your token", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(white: 0.5, alpha: 1),
        ])
        textField.placeholder = "Input your token"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.backgroundColor = .darkGray
        textField.textColor = UIColor(white: 0.6, alpha: 0.6)
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.backgroundColor = .darkGray
        button.setTitleColor(.darkText, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 50)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.64, alpha: 0.25)
        layout()
        signInButton.addTarget(self, action: #selector(pressedSignInButton), for: .touchUpInside)
    }
    
    @objc func pressedSignInButton() {
        guard tokenTextField.text != "" else {
            present(AlertControllerFactory.createNotificationAlertController("Validation Error", message: "Token field must be non-empty"), animated: true)
            return
        }
        
        let provider = MoyaProvider<GitHubService>()
        provider.request(.isUserInGitHubSystem(token: tokenTextField.text!)) { response in
            switch response {
            case .success(let success):
                switch success.statusCode {
                case 200:
                    GitHubService.token = self.tokenTextField.text!
                    let userProfileVC = UserProfileViewController()
                    let navigationController = UINavigationController(rootViewController: userProfileVC)
                    navigationController.modalPresentationStyle = .fullScreen
                    navigationController.modalTransitionStyle = .crossDissolve
                    self.present(navigationController, animated: true)
                default:
                    self.present(AlertControllerFactory.createNotificationAlertController("Bad token", message: "Try another token"), animated: true)
                    self.tokenTextField.text = ""
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }
    
    private func layout() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.height.equalTo(250)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(70)
        }
        
        view.addSubview(tokenTextField)
        tokenTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
    }
}
