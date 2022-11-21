//
//  ViewController.swift
//  users
//
//  Created by User on 09.11.2022.
//


import UIKit

class ViewController: UIViewController {
        
    
    
    var users: [User] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    override func loadView() {
        let url = "https://randomuser.me/api/?results=100"
        parseJSON(url: url) {
//            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewController") as? UserDetailsTableViewController else {
            return
        }
        userDetailsVC.user = users[indexPath.row]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
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
    
    
    
}
