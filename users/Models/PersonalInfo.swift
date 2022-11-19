//
//  PersonalInfo.swift
//  users
//
//  Created by User on 12.11.2022.
//

import Foundation

enum UserDetailsSections: String {
    case fullNameAndPhoto = ""
    case birthday = "Date of birth"
    case contactInfo = "Contact info"
    case adress = "Adress"
}

enum UserInfo: String {
    case email = "Email"
    case phone = "Phone"
    case birthday = "Birthday"
    case city = "City"
    case street = "Street"
    case firstName
    case lastName
    case photoData
}

enum Service: String {
    case serviceName = "UsersTable"
    case keyForUserDefaults = "UserProfile"
}
