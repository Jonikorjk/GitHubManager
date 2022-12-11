//
//  UserProfileViewController.swift
//  GitHubManager
//
//  Created by User on 06.12.2022.
//

import Moya
import Alamofire

class UserProfileViewController: UIViewController {
    lazy var tableView = UITableView()
    typealias Section = SectionsForProfile
    var sections: [Section] = [.profile, .repositories]
    var user: User?
    var repositories: [Repository]? {
        didSet {
            repositories = repositories?.sorted {
                $0.updateDate ?? Date() > $1.updateDate ?? Date() ? true : false
            }
        }
    }
    lazy var refreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(swipeRefresh), for: .allEvents)
        return refresh
    }()
    let provider = MoyaProvider<GitHubService>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "UserInfoTableViewCell")
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: "RepositoryTableViewCell")
        tableView.separatorStyle = .none
        getUserRequest()
        getRepositoriesRequest()
        configurateNavigationController()
        layout()
    }
    
    @objc private func swipeRefresh() {
        getRepositoriesRequest()
        tableView.refreshControl?.endRefreshing()
    }
    
    func getUserRequest() {
        provider.request(.getUser) { response in
            switch response {
            case .success(let res):
                do {
                    self.user = try JSONDecoder().decode(User.self, from: res.data)
                    self.tableView.reloadData()
                } catch { print(error) }
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    func getRepositoriesRequest() {
        provider.request(.getRepositoriesOfCurrentUser) { response in
            switch response {
            case .success(let res):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    self.repositories = try decoder.decode([Repository].self, from: res.data)
                    self.tableView.reloadData()
                } catch { print(error) }
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func configurateNavigationController() {
        self.navigationController?.navigationBar.topItem?.title = "GitHub"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "add"),
            style: .done,
            target: self,
            action: #selector(addRepositoryButton))
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray]
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = .gray
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: -10)
    }
    
    @objc func addRepositoryButton() {
        let createRepositoryVC = CreateRepositoryViewController()
        navigationController?.pushViewController(createRepositoryVC, animated: true)
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.profile.rawValue: return 1
        case Section.repositories.rawValue: return repositories?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.profile.rawValue: return "Profile"
        case Section.repositories.rawValue: return "Repositories"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.profile.rawValue: return 200
        case Section.repositories.rawValue: return 120
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.repositories.rawValue:
            let repositoryDetailsVC = RepositoryDetailsViewController()
            repositoryDetailsVC.repository = repositories?[indexPath.row]
            navigationController?.pushViewController(repositoryDetailsVC, animated: true)
        default: print("nothing")
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.profile.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as! UserInfoTableViewCell
            cell.nameLabel.text = user?.name
            cell.emailLabel.text = user?.email
            AF.request(user?.avatarUrl ?? "").response { response in
                switch response.result {
                case .success(let data):
                    cell.avatarImageView.image = UIImage(data: data ?? Data())
                case .failure(let fail):
                    print(fail.errorDescription ?? "")
                }
            }
            return cell
        case Section.repositories.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as! RepositoryTableViewCell
            let currentRepository = repositories?[indexPath.row]
            cell.nameLabel.text = currentRepository?.name
            cell.languageLabel.text = currentRepository?.language
            cell.lastDateLabel.text = convertDateToString(currentRepository?.updateDate, style: .short)
            return cell
        default: return UITableViewCell()
        }
    }
}
