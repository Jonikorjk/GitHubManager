//
//  UserDefaultsController.swift
//  users
//
//  Created by User on 15.11.2022.
//

import Foundation

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

enum UserData: String {
    case login
    case password
    case birthday
    case phone
    case email
    case street
    case city
    case photo
    case firstName
    case lastName 
}

//class UserDefaultsController {
//    private let key = "profile"
//
//    private var storage: Dictionary<UserData, String>
//
//    func save(data: Dictionary<UserData, String>) {
//        let user = UserDefaults.standard
//        user
//        storage =
//    }
//
//    func load() -> Dictionary<String, String>{
//
//    }
//
//
//}
