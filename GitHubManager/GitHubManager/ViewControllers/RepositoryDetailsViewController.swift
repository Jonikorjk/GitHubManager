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
    var values: [Int] = []
    var repository: Repository! // force-unwrap because when we tap on repository cell the repository already exists
    var provider = MoyaProvider<GitHubService>()
    var languagesForTable = [String]() {
        didSet {
            languagesForTable = languagesForTable.sorted { l1, l2 in
                return Double(l1.split(separator: " ")[1])! > Double(l2.split(separator: " ")[1])!
            }
        }
    }
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        addButtonsToBar()
        tableView.register(NamedTableViewCell.self, forCellReuseIdentifier: "NamedTableViewCell")
        tableView.register(AssosiateTableViewCell.self, forCellReuseIdentifier: "AssosiateTableViewCell")
        values = [repository.starsCount, repository.forksCount, repository.openIssuesCount]
        tableView.delegate = self
        tableView.dataSource = self
        provider.request(.getLanguagesOfRepository(owner: repository.owner.login, repo: repository.name)) { response in
            switch response {
            case .success(let response):
                do {
                    let languages = try JSONDecoder().decode([String: Int].self, from: response.data)
                    self.languagesForTable = self.prepareLanguagesForTable(dict: languages)
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tappedOpenBrowserButton() {
        guard let url = URL(string: repository.selfUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func tappedDeleteRepositoryButton() {
        let alert = UIAlertController(title: "Warning", message: "Do you actually want to DELETE this repository?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {_ in
            self.provider.request(.removeRepositoryOfCurrentUser(owner: self.repository.owner.login, repo: self.repository.name)) { response in
                switch response {
                case .success(let a):
                    print(a)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let err):
                    print(err)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func tappedShareButton() {
        guard let url = URL(string: repository.selfUrl) else { return }
        let shareController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareController, animated: true)
    }
    
    private func addButtonsToBar() {
        let openBrowserButton = UIBarButtonItem(image: UIImage(named: "openBrowser"), style: .plain, target: self, action: #selector(tappedOpenBrowserButton))
        openBrowserButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10)
        
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(tappedShareButton))
        shareButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10)
        
        let deleteButton = UIBarButtonItem(image: UIImage(named: "trash"), style: .plain, target: self, action: #selector(tappedDeleteRepositoryButton))
        deleteButton.tintColor = .red
        deleteButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10)
        
        navigationItem.rightBarButtonItems = [deleteButton, shareButton, openBrowserButton]
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
        
    private func prepareLanguagesForTable(dict: [String: Int]) -> [String] {
        let count = countOfRowsInProject(dict: dict)
        var result: [String] = []
        for (k, v) in dict {
            result.append(k + ": " + calculatePercentage(count, v) + " %")
        }
        return result
    }
    
    private func countOfRowsInProject(dict: [String: Int]) -> Int {
        var count = 0
        for v in dict.values {
            count += v
        }
        return count
    }
    
    private func calculatePercentage(_ count: Int, _ value: Int) -> String {
        var result = Double(value * 100) / Double(count)
        result = round(result, toNearest: 0.01)
        return result.formatted()
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
