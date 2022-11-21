//
//  ViewController.swift
//  users
//
//  Created by User on 09.11.2022.
//


import UIKit

class UsersTableAndCollectionsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
        
    var users: [User] = []

    private func parseJSON(url: String, _ completiton: @escaping () -> Void) {
        guard let apiUrl = URL(string: url) else {
            fatalError("Failed to get api url")
        }
        
        let session = URLSession.shared
        session.dataTask(with: apiUrl) { data, response, error in
            guard error == nil, data != nil else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            do {
                let parsedUsers = try decoder.decode(Users.self, from: data!)
                self.users = parsedUsers.results // results storing [User]
                DispatchQueue.main.async {
                    completiton()
                }
            } catch {
                print(error)
            }
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true
        tableView.rowHeight = 80
        let url = "https://randomuser.me/api/?results=107"
        parseJSON(url: url) {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func tappedSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            collectionView.isHidden = true
        case 1:
            collectionView.isHidden = false
            tableView.isHidden = true
        default:
            print("error")
        }
    }
}

extension UsersTableAndCollectionsViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellTable", for: indexPath) as! UserTableViewCell
        let currentUser = users[indexPath.row]
        cell.firstNameLabel.text = currentUser.name.first
        cell.lastNameLabel.text = currentUser.name.last
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"

        cell.birthdayLabel.text = dateFormatter.string(from: currentUser.dob.date)

        guard let imageUrl = URL(string: currentUser.picture.medium) else {
            fatalError("failed to get image url")
        }
        
        let session = URLSession.shared
        session.dataTask(with: imageUrl) {data, _, _ in
            guard let dataImage = data else { return }
            DispatchQueue.main.async {
                cell.photoImageView.image = UIImage(data: dataImage)
            }
        }.resume()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewController") as? UserDetailsTableViewController else {
            return
        }
        userDetailsVC.user = users[indexPath.row]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}

extension UsersTableAndCollectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section * 2 + indexPath.item) >= users.count {
            return
        }
        guard let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewController") as? UserDetailsTableViewController else {
            return
        }
        userDetailsVC.user = users[indexPath.section * 2 + indexPath.item]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (users.count % 2 != 0) {
            return (users.count + 1) / 2
        }
        return users.count / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ((indexPath.section * 2 + indexPath.item) >= users.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCollectionCell", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCellCollectionView", for: indexPath) as! UserCollectionViewCell
        let currentUser = users[indexPath.section * 2 + indexPath.item]

        cell.firstNameLabel.text = currentUser.name.first
        cell.lastNameLaber.text = currentUser.name.last
        
        guard let imageUrl = URL(string: currentUser.picture.large) else {
            fatalError("failed to get image url")
        }

        let session = URLSession.shared
        session.dataTask(with: imageUrl) {data, _, _ in
            guard let dataImage = data else { return }
            DispatchQueue.main.async {
                cell.photoImageView.image = UIImage(data: dataImage)
            }
        }.resume()
        
        return cell
    }
}
