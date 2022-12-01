//
//  UserDetailsTableViewController.swift
//  users
//
//  Created by User on 12.11.2022.
//

import UIKit


class UserDetailsTableViewController: UITableViewController {
    var convienceUser: UserClass!
    var sections: [UserDetailsSections] = [.fullNameAndPhotoSection, .birthdaySection, .contactInfoSection, .adressSection]
    var userInfo: [UserDetailsSections: [UserInfo: String]]!
    @IBOutlet var heartButton: UIBarButtonItem!
        
    override func loadView() {
        super.loadView()
        userInfo = [
            .fullNameAndPhotoSection: [.birthday: ""],
            .birthdaySection: [.birthday: convienceUser.birthday],
            .contactInfoSection: [
                .email: convienceUser.email,
                .phone: convienceUser.phone
            ],
            .adressSection: [
                .city: convienceUser.city,
                .street: convienceUser.street
            ]
        ]
        
    }
    
    private func setHeartImage() {
        heartButton.image = convienceUser.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        heartButton.tintColor = .systemPink
    }
    
    @IBAction func pressedHeartButton(_ sender: Any) {
        convienceUser.isFavorite = !convienceUser.isFavorite
        setHeartImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setHeartImage()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo[sections[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequsitesTableViewCell", for: indexPath) as! RequsitesTableViewCell
            cell.firstNameLabel.text = convienceUser.firstName
            cell.lastNameLabel.text = convienceUser.lastName
            
            ApiClient.downloadUserImage(convienceUser.largePhoto) { dataImage in
                cell.photoImageView.image = UIImage(data: dataImage)
            }
            
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
}
