//
//  PersonalInfo.swift
//  users
//
//  Created by User on 12.11.2022.
//

import Foundation

enum UserDetailsSections: String {
    case fullNameAndPhotoSection = ""
    case birthdaySection = "Date of birth"
    case contactInfoSection = "Contact info"
    case adressSection = "Adress"
    case additionalInfoSection = "Additional info"
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
    case additionalInfo
}

enum Service: String {
    case serviceName = "UsersTable"
    case keyForUserDefaults = "UserProfile"
}
