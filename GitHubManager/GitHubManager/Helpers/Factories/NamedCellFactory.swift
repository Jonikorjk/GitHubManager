//
//  NamedCellFactory.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import UIKit

func namedCell(tableView: UITableView, textLabel: String?, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NamedTableViewCell", for: indexPath) as! NamedTableViewCell
    cell.nameLabel.text = textLabel == nil ? "No info" : textLabel
    return cell
}
