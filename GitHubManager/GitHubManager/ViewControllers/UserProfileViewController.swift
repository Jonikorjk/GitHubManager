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
    
    var sections: [Sections] = [.profile, .repositories]
    var user: User?
    var repositories: [Repository]? {
        didSet {
            repositories = repositories?.sorted { rep1, rep2 in
                return rep1.updateDate ?? Date() > rep2.updateDate ?? Date() ? true : false
            }
        }
    }
    let provider = MoyaProvider<GitHubService>()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "UserInfoTableViewCell")
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: "RepositoryTableViewCell")

//        tableView.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.64, alpha: 0.25)
//        view.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.64, alpha: 0.25)
        
        provider.request(.getUser) { response in
            switch response {
            case .success(let res):
                do {
                    self.user = try JSONDecoder().decode(User.self, from: res.data)
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
        
        provider.request(.getRepositoriesOfCurrentUser) { response in
            switch response {
            case .success(let res):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    self.repositories = try decoder.decode([Repository].self, from: res.data)
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
        configurateNavigationController()
        layout()
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
        return
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.profile.rawValue: return 1
        case Sections.repositories.rawValue: return repositories?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.profile.rawValue: return "Profile"
        case Sections.repositories.rawValue: return "Repositories"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Sections.profile.rawValue: return 200
        case Sections.repositories.rawValue: return 120
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.profile.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as! UserInfoTableViewCell
            cell.nameLabel.text = user?.name ?? ""
            cell.emailLabel.text = user?.email ?? ""
            AF.request(user?.avatarUrl ?? "").response { response in
                switch response.result {
                case .success(let data):
                    cell.avatarImageView.image = UIImage(data: data ?? Data())
                case .failure(let fail):
                    print(fail.errorDescription ?? "")
                }
            }
            return cell
        case Sections.repositories.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as! RepositoryTableViewCell
            let currentRepository = repositories?[indexPath.row]
            cell.nameLabel.text = currentRepository?.name ?? ""
            cell.languageLabel.text = currentRepository?.language ?? ""
            cell.lastDateLabel.text = convertDateToString(currentRepository?.updateDate, style: .short)
            return cell
        default: return UITableViewCell()
        }
    }
}
