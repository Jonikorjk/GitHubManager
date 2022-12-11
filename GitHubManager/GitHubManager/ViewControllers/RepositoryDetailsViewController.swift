//
//  RepositoryDetailsViewController.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import Moya

class RepositoryDetailsViewController: UIViewController {
    typealias Section = SectionsForRepositoryDetails
    var keys: [AdditionalInfo] = [.stars, .forks, .issues]
    lazy var actionsSheets = {
        let actionSheet = UIAlertController(title: "What do you want?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            self.tappedShareButton()
        })
        actionSheet.addAction(UIAlertAction(title: "Open In Safari", style: .default) { _ in
            self.tappedOpenBrowserButton()
        })
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.tappedDeleteRepositoryButton()
        })
        return actionSheet
    }()
    var values: [Int] = []
    var repository: Repository! // force-unwrap because when we tap on repository cell the repository already exists
    var provider = MoyaProvider<GitHubService>()
    var languagesForTable = [String]() {
        didSet {
            languagesForTable = languagesForTable.sorted {
                Double($0.split(separator: " ")[1]) ?? Double() > Double($1.split(separator: " ")[1]) ?? Double()
            }
        }
    }
    var tableView = UITableView()

    override func loadView() {
        super.loadView()
        provider.request(.getLanguagesOfRepository(owner: repository.owner.login, repo: repository.name)) { response in
            switch response {
            case .success(let response):
                do {
                    let languages = try JSONDecoder().decode([String: Int].self, from: response.data)
                    self.languagesForTable = self.prepareLanguagesForTable(dict: languages)
                    self.tableView.reloadData()
                } catch { print(error) }
            case .failure(let error): print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NamedTableViewCell.self, forCellReuseIdentifier: "NamedTableViewCell")
        tableView.register(AssosiateTableViewCell.self, forCellReuseIdentifier: "AssosiateTableViewCell")
        addListOfActionsButton()
        tableView.delegate = self
        tableView.dataSource = self
        values = [repository.starsCount, repository.forksCount, repository.openIssuesCount]
        layout()
    }
    
    func tappedOpenBrowserButton() {
        guard let url = URL(string: repository.selfUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    func tappedDeleteRepositoryButton() {
        let alert = UIAlertController(title: "Warning", message: "Do you actually want to DELETE this repository?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {_ in
            self.provider.request(.removeRepositoryOfCurrentUser(owner: self.repository.owner.login, repo: self.repository.name)) { response in
                switch response {
                case .success(_): self.navigationController?.popViewController(animated: true)
                case .failure(_): self.present(AlertControllerFactory.createNotificationAlertController("Bad Internet Connection", message: "Try Again"), animated: true)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
    
    func tappedShareButton() {
        guard let url = URL(string: repository.selfUrl) else { return }
        let shareController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareController, animated: true)
    }
    
    @objc private func pressedActionSheetButton() { present(actionsSheets, animated: true) }
    
    private func addListOfActionsButton() {
        navigationItem.title = "Details"
        let barButtonItem =  UIBarButtonItem(image: UIImage(named: "actions"), style: .plain, target: self, action: #selector(pressedActionSheetButton))
        barButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
        
    private func prepareLanguagesForTable(dict: [String: Int]) -> [String] {
        let count = dict.reduce(0) { $0 + $1.value }
        
        func calculatePercentage(_ value: Int) -> String {
            var result = Double(value * 100) / Double(count)
            result = round(result, toNearest: 0.01)
            return result.formatted()
        }
        
        var result: [String] = []
        dict.forEach { k, v in
            result.append(k + ": " + calculatePercentage(v) + " %")
        }
        return result
    }
}

extension RepositoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 5 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.name.rawValue, Section.fullName.rawValue, Section.description.rawValue: return 1
        case Section.languages.rawValue: return languagesForTable.count
        case Section.additionalInfo.rawValue: return keys.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.name.rawValue:
            return namedCell(tableView: tableView, textLabel: repository.name, indexPath: indexPath)
        case Section.fullName.rawValue:
            return namedCell(tableView: tableView, textLabel: repository.fullName, indexPath: indexPath)
        case Section.description.rawValue:
            return namedCell(tableView: tableView, textLabel: repository.description, indexPath: indexPath)
        case Section.additionalInfo.rawValue:
            let result = keys[indexPath.row].rawValue + ": " + values[indexPath.row].formatted()
            return namedCell(tableView: tableView, textLabel: result, indexPath: indexPath)
        case Section.languages.rawValue:
            return namedCell(tableView: tableView, textLabel: languagesForTable[indexPath.row], indexPath: indexPath)
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.name.rawValue: return "Name"
        case Section.fullName.rawValue: return "Full Name"
        case Section.description.rawValue: return "Description"
        case Section.additionalInfo.rawValue: return "Additional Info"
        case Section.languages.rawValue: return "Languages"
        default: return ""
        }
    }
}
