//
//  UserDetailsTableViewController.swift
//  users
//
//  Created by User on 12.11.2022.
//

import UIKit


class UserDetailsTableViewController: UITableViewController {

    var user: User!
    var sections: [UserDetailsSections] = [.fullNameAndPhoto, .birthday, .contactInfo, .adress]
    
    var userInfo: Dictionary<UserDetailsSections, [UserInfo:String]>!
    
    override func loadView() {
        super.loadView()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let birthday = dateFormatter.string(from: user.dob.date)
    
        userInfo = [
            .fullNameAndPhoto: [.birthday: ""], // for rowCount = 1 (check numberOfRowsInSection)
            .birthday: [.birthday: birthday],
            .contactInfo: [
                .email: user.email,
                .phone: user.phone
            ],
            .adress: [
                .city: user.location.city,
                .street: user.location.street.fullName,
            ]
        ]
//
//        var smth: Dictionary<String, String> = [
//            "login": user.login.username,
//            "password": user.login.password,
//            "birthday": birthday,
//            "phone": user.phone,
//            "email": user.email,
//            "street": user.location.street.fullName,
//            "city": user.location.city,
//            "photo": user.picture.large,
//            "firstName": user.name.first,
//            "lastName": user.name.last
//        ]
//        let ud = UserDefaults.standard
//        ud.set(smth, forKey: "userProfile")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.firstNameLabel.text = user.name.first
            cell.lastNameLabel.text = user.name.last
            
            guard let userPhotoUrl = URL(string: user.picture.large) else {
                fatalError("failed to get url user's photo")
            }
            
            let session = URLSession.shared
            session.dataTask(with: userPhotoUrl) {data, _, _ in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                cell.photoImageView.image = UIImage(data: imageData)
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
