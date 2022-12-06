//
//  dateConverter.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import Foundation

func convertDateToString(_ date: Date?, style: DateFormatter.Style) -> String? {
    guard let date = date else { return nil }
    let formatter = DateFormatter()
    formatter.dateStyle = style
    return formatter.string(from: date)
}

