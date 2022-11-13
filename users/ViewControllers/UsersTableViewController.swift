//
//  UsersTableViewController.swift
//  users
//
//  Created by User on 10.11.2022.
//


import UIKit

class UsersTableViewController: UITableViewController {
    var users: [User] = []
    
        
    override func loadView() {
        super.loadView()
        let url = "https://randomuser.me/api/?results=50"
    
        parseJSON(url: url) {
            self.tableView.reloadData()
        }
        
//        
//        tabBarController?.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person"), tag: 0)
//        tabBarController?.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person"), tag: 1)
//        tabBarController?.setViewControllers([self, UserDetailsTableViewController()], animated: true)

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewController") as? UserDetailsTableViewController else {
            return
        }
        userDetailsVC.user = users[indexPath.row]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    func parseJSON(url: String, _ completiton: @escaping () -> Void) {
        
        guard let apiUrl = URL(string: url) else {
            fatalError("Failed to get api url")
        }
        let session = URLSession.shared
        let data = session.dataTask(with: apiUrl) { data, response, error in
            guard error == nil, data != nil else { return }
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            do {
                let parsedUsers = try decoder.decode(Users.self, from: data!)
                self.users = parsedUsers.results // results storing [User]
                print(self.users)
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
        
        
        
        tableView.rowHeight = 80
        
        
        
         // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        do {
            let imageData = try Data(contentsOf: imageUrl)
            cell.photoImageView.image = UIImage(data: imageData)
        } catch {
            fatalError("failed to get image data")
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
