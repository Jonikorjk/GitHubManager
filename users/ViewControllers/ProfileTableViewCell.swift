//
//  UserDetailsTableViewController.swift
//  users
//
//  Created by User on 12.11.2022.
//

import UIKit


class ProfileTableViewCell: UITableViewController {
    var userInfo: [UserDetailsSections: [UserInfo: String]]!
    var sections: [UserDetailsSections] = [.fullNameAndPhotoSection, .birthdaySection, .contactInfoSection, .adressSection, .additionalInfoSection]
    var profile: [String: String] = UserDefaults.standard.dictionary(forKey: Service.keyForUserDefaults.rawValue) as! Dictionary<String,String>
    
    private func convertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String) else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
    
    override func loadView() {
        super.loadView()
            userInfo = [
            .fullNameAndPhotoSection: [.birthday: ""], // for rowCount = 1 (check numberOfRowsInSection)
            .birthdaySection: [.birthday: profile[UserInfo.birthday.rawValue]!],
            .contactInfoSection: [
                .phone: profile[UserInfo.phone.rawValue]!,
                .email: profile[UserInfo.email.rawValue]!
            ],
            .adressSection: [
                .street: profile[UserInfo.street.rawValue]!,
                .city: profile[UserInfo.city.rawValue]!
            ],
            .additionalInfoSection: [.additionalInfo: profile[UserInfo.additionalInfo.rawValue]!]
        ]
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
            cell.firstNameLabel.text = profile[UserInfo.firstName.rawValue]
            cell.lastNameLabel.text = profile[UserInfo.lastName.rawValue]
            cell.photoImageView.image = convertBase64StringToImage(imageBase64String: profile[UserInfo.photoData.rawValue]!)
            tableView.rowHeight = 150
            cell.isUserInteractionEnabled = false
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as! TextViewTableViewCell
            cell.additionalInfo.text = profile[UserInfo.additionalInfo.rawValue]
            tableView.rowHeight = 145
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
