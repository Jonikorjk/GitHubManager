//
//  CreateRepositoryViewController.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import Moya

class CreateRepositoryViewController: UIViewController {
    let provider = MoyaProvider<GitHubService>()
    var repositoryType: Repository.RepositoryType = .Public
    var addReadMe: Repository.addReadMe = .no
    var gitIgnoreTemplate: String = ""
    var license: String = ""
    
    lazy var repositoryNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Name"
        label.font = UIFont(name: "System", size: 14)
        return label
    }()
    
    lazy var repositoryNameTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Your repository name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var repositoryDescriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Description"
        label.font = UIFont(name: "System", size: 14)
        return label
    }()
    
    lazy var repositoryDescriptionTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .gray
        textView.layer.cornerRadius = 15
        return textView
    }()
    
    lazy var repositoryVisabilityLabel: UILabel = {
       var label = UILabel()
        label.text = "Visability"
        return label
    }()
    
    lazy var publicOrPrivateButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.menu = UIMenu(children: [
            UIAction(title: "Public", handler: { _ in self.repositoryType = .Public}),
            UIAction(title: "Private", handler: { _ in self.repositoryType = .Private})
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    lazy var addReadMeLabel: UILabel = {
       var label = UILabel()
        label.text = "Add ReadMe"
        return label
    }()
    
    lazy var addReadMeButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.menu = UIMenu(children: [
            UIAction(title: "No", handler: { _ in self.addReadMe = .no}),
            UIAction(title: "Yes", handler: { _ in self.addReadMe = .yes})
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    lazy var gitIgnoreTemplateLabel: UILabel = {
        var label = UILabel()
        label.text = ".gitignore"
        return label
    }()
    
    lazy var gitIgnoreTemplateButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        let action = UIAction(title: "None", handler: { _ in self.license = ""})
        button.menu = UIMenu(children: [action])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    lazy var licenseLabel: UILabel = {
        var label = UILabel()
        label.text = "License"
        return label
    }()
    
    lazy var licenseButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.layer.cornerRadius = 15
        let action = UIAction(title: "None", handler: { _ in self.license = ""})
        button.menu = UIMenu(children: [action])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    lazy var createRepositoryButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.setTitle("Create Repository", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Plain", size: 30)
        button.addTarget(self, action: #selector(pressedCreateRepositoryButton), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        getRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
    
    @objc func pressedCreateRepositoryButton() {
        guard repositoryNameTextField.text != "" else {
            present(AlertControllerFactory.createNotificationAlertController("Validation Error", message: "Repository name is required"), animated: true)
            return
        }
        createRepositoryRequest()
    }
    
    private func createRepositoryRequest() {
        let isPrivate = repositoryType == Repository.RepositoryType.Private ? true : false
        let addReadMe = addReadMe == Repository.addReadMe.yes ? true : false
        
        provider.request(.createRepository(name: repositoryNameTextField.text!, description: repositoryDescriptionTextView.text ?? "", private: isPrivate, gitignoreTemplate: gitIgnoreTemplate, licenseTemplate: license, autoInit: addReadMe)) { response in
            switch response {
            case .success(let success):
                switch success.statusCode {
                case 201: self.navigationController?.popViewController(animated: true)
                default: self.present(AlertControllerFactory.createNotificationAlertController("Server Error", message: "Status code: \(success.statusCode)"), animated: true)
                }
            case .failure(_): self.present(AlertControllerFactory.createNotificationAlertController("Error", message: "Failed to create repository. Try again"), animated: true)
            }
        }
    }
    
    private func getRequests() {
        provider.request(.getListGitIgnoreTemplates) { response in
            switch response {
            case .success(let success):
                do {
                    let templates = try JSONDecoder().decode([String].self, from: success.data)
                    var actions = [UIAction]()
                    actions.append(UIAction(title: "None", handler: { _ in self.gitIgnoreTemplate = ""}))
                    for v in templates {
                        actions.append(UIAction(title: v, handler: { _ in self.gitIgnoreTemplate = v}))
                    }
                    self.gitIgnoreTemplateButton.menu = UIMenu(children: actions)
                } catch { print(error) }
            case .failure(let error): print(error)
            }
        }
        provider.request(.getCommonLicenses) { response in
            switch response {
            case .success(let success):
                do {
                    let licenses = try JSONDecoder().decode([License].self, from: success.data)
                    var actions = [UIAction]()
                    actions.append(UIAction(title: "None", handler: { _ in self.license = ""}))
                    for v in licenses {
                        actions.append(UIAction(title: v.name, handler: { _ in self.license = v.key}))
                    }
                    self.licenseButton.menu = UIMenu(children: actions)
                } catch { print(error) }
            case .failure(let error): print(error)
            }
        }
    }
        
    private func layout() {
        view.addSubview(repositoryNameLabel)
        repositoryNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.height.equalTo(16)
        }
        
        view.addSubview(repositoryNameTextField)
        repositoryNameTextField.snp.makeConstraints { make in
            make.top.equalTo(repositoryNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(45)
        }
        
        view.addSubview(repositoryDescriptionLabel)
        repositoryDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(repositoryNameTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        view.addSubview(repositoryDescriptionTextView)
        repositoryDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        view.addSubview(repositoryVisabilityLabel)
        repositoryVisabilityLabel.snp.makeConstraints { make in
            make.top.equalTo(repositoryDescriptionTextView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(16)
        }
        
        view.addSubview(publicOrPrivateButton)
        publicOrPrivateButton.snp.makeConstraints { make in
            make.centerY.equalTo(repositoryVisabilityLabel.snp.centerY)
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(repositoryVisabilityLabel.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        view.addSubview(addReadMeLabel)
        addReadMeLabel.snp.makeConstraints { make in
            make.top.equalTo(repositoryVisabilityLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(16)
        }
        
        view.addSubview(addReadMeButton)
        addReadMeButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(addReadMeLabel.snp.trailing).offset(16)
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.centerY.equalTo(addReadMeLabel.snp.centerY)
            make.centerX.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        view.addSubview(gitIgnoreTemplateLabel)
        gitIgnoreTemplateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
            make.top.equalTo(addReadMeLabel.snp.bottom).offset(40)
        }
        
        view.addSubview(gitIgnoreTemplateButton)
        gitIgnoreTemplateButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.leading.greaterThanOrEqualTo(gitIgnoreTemplateLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.centerY.equalTo(gitIgnoreTemplateLabel.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(licenseLabel)
        licenseLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(gitIgnoreTemplateLabel.snp.bottom).offset(40)
            make.height.equalTo(16)
        }
        
        view.addSubview(licenseButton)
        licenseButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.leading.greaterThanOrEqualTo(licenseLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.centerY.equalTo(licenseLabel.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(createRepositoryButton)
        createRepositoryButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.top.greaterThanOrEqualTo(licenseLabel.snp.bottom).offset(20)
        }
    }
}
