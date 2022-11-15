//
//  UserDetailsTableViewController.swift
//  users
//
//  Created by User on 12.11.2022.
//

import UIKit




class ProfileTableViewCell: UITableViewController {

    var userInfo: Dictionary<UserDetailsSections, [UserInfo:String]>!
    var sections: [UserDetailsSections] = [.fullNameAndPhoto, .birthday, .contactInfo, .adress]
    var profile: Dictionary<String,String> = UserDefaults.standard.dictionary(forKey: "userProfile") as! Dictionary<String,String>
//    var profile: Dictionary<String,String> = [:]
    
    override func loadView() {
        super.loadView()
//        KeyChainClass.save(profile["password"]!.data(using: .utf8)!, service: "usersManager", account: profile["login"]!)

            userInfo = [
            .fullNameAndPhoto: [.birthday: ""], // for rowCount = 1 (check numberOfRowsInSection)
            .birthday: [.birthday: profile["birthday"]!],
            .contactInfo: [
                .phone: profile["phone"]!,
                .email: profile["email"]!
            ],
            .adress: [
                .street: profile["street"]!,
                .city: profile["city"]!
            ]
        
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let info = userInfo[sections[section]] else {
            return 0
        }
        return info.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequsitesTableViewCell", for: indexPath) as! RequsitesTableViewCell
            cell.firstNameLabel.text = profile["firstName"]
            cell.lastNameLabel.text = profile["lastName"]
            guard let userPhotoUrl = URL(string: profile["photo"]!) else {
                fatalError("failed to get url user's photo")
            }
            
            let session = URLSession.shared
            session.dataTask(with: userPhotoUrl) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    cell.photoImageView.image = UIImage(data: data)
                }
            }.resume()
        
            tableView.rowHeight = 150
            cell.isUserInteractionEnabled = false

            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell", for: indexPath) as! UserDetailsTableViewCell
            let info = userInfo[sections[indexPath.section]]
            var i = 0
            for (k, v) in info! {
                if i == indexPath.row {
                    cell.info.text = k.rawValue + ": " + v
                }
                i += 1
            }
            tableView.rowHeight = 45
            return cell
        }
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
