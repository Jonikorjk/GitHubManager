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
    private var countOfUsersInGroup = 2

    var convienceUsers: [UserClass]?
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true
        tableView.rowHeight = 80
        DownloadUsers.downloadUsers(amountOfUsers: 50) { users in
            UserStorage.load(users.results)
            self.convienceUsers = UserStorage.read()
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
        return convienceUsers?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellTable", for: indexPath) as! UserTableViewCell
        let currentUser = convienceUsers![indexPath.row]
        cell.firstNameLabel.text = currentUser.firstName
        cell.lastNameLabel.text = currentUser.lastName
        cell.birthdayLabel.text = currentUser.birthday
        ApiClient.downloadUserImage(currentUser.largePhoto) { dataImage in
            cell.photoImageView.image = UIImage(data: dataImage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewController") as! UserDetailsTableViewController
        userDetailsVC.convienceUser = UserStorage.read()[indexPath.row]
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}

extension UsersTableAndCollectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsTableViewController") as! UserDetailsTableViewController
        userDetailsVC.convienceUser = convienceUsers?[indexPath.row] ?? nil
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return convienceUsers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCellCollectionView", for: indexPath) as! UserCollectionViewCell
        let currentUser = convienceUsers![indexPath.item]
        cell.firstNameLabel.text = currentUser.firstName
        cell.lastNameLaber.text = currentUser.lastName
        cell.heartImageView.isHidden = !currentUser.isFavorite
        ApiClient.downloadUserImage(currentUser.largePhoto) { dataImage in
            cell.photoImageView.image = UIImage(data: dataImage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame
        let width = (frame.width - CGFloat(30)) / CGFloat(countOfUsersInGroup)
        let height = width
        return CGSize(width: width, height: height)
    }
}
