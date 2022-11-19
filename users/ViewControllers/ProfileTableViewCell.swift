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
    var profile: Dictionary<String,String> = UserDefaults.standard.dictionary(forKey: Service.keyForUserDefaults.rawValue) as! Dictionary<String,String>
    
    private func convertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String) else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
    
    override func loadView() {
        super.loadView()
            userInfo = [
            .fullNameAndPhoto: [.birthday: ""], // for rowCount = 1 (check numberOfRowsInSection)
            .birthday: [.birthday: profile[UserInfo.birthday.rawValue]!],
            .contactInfo: [
                .phone: profile[UserInfo.phone.rawValue]!,
                .email: profile[UserInfo.email.rawValue]!
            ],
            .adress: [
                .street: profile[UserInfo.street.rawValue]!,
                .city: profile[UserInfo.city.rawValue]!
            ]
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.firstNameLabel.text = profile[UserInfo.firstName.rawValue]
            cell.lastNameLabel.text = profile[UserInfo.lastName.rawValue]
            cell.photoImageView.image = convertBase64StringToImage(imageBase64String: profile[UserInfo.photoData.rawValue]!)
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
