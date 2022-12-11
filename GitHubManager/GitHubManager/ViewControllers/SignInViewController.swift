//
//  ViewController.swift
//  GitHubManager
//
//  Created by User on 05.12.2022.
//

import SnapKit
import Moya

class SignInViewController: UIViewController {
    let provider = MoyaProvider<GitHubService>()

    lazy var logoImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "github")
        return imageView
    }()
    
    lazy var tokenTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Input your token"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 2
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Plain", size: 30)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        signInButton.addTarget(self, action: #selector(pressedSignInButton), for: .touchUpInside)
    }
    
    @objc func pressedSignInButton() {
        guard tokenTextField.text != "" else {
            present(AlertControllerFactory.createNotificationAlertController("Validation Error", message: "Token field must be non-empty"), animated: true)
            return
        }
        
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
                self.present(AlertControllerFactory.createNotificationAlertController("Bad Internet Connection", message: "Timeout"), animated: true)
            }
        }
    }
    
    private func layout() {
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
        view.addSubview(tokenTextField)
        
        logoImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.height.equalTo(250)
        }
        
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(70)
        }
        
        tokenTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
    }
}
