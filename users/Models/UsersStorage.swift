//
//  UsersStorage.swift
//  users
//
//  Created by User on 22.11.2022.
//

import Foundation

class UserClass {
    var isFavorite = false
    
    init(firstName: String, lastName: String, email: String,
              phone: String, birthday: String, city: String,
              street: String, largePhoto: String, additionalInfo: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.birthday = birthday
        self.city = city
        self.street = street
        self.largePhoto = largePhoto
        self.additionalInfo = additionalInfo
    }
    
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var birthday: String
    var city: String
    var street: String
    var largePhoto: String
    var additionalInfo: String
}

class UserStorage {
    static private var users: [UserClass] = []
    
    static func load(_ users: [User]) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        for v in users {
            self.users.append(UserClass(
                firstName: v.name.first,
                lastName: v.name.last,
                email: v.email,
                phone: v.phone,
                birthday: formatter.string(from: v.dob.date),
                city: v.location.city,
                street: v.location.street.fullName,
                largePhoto: v.picture.large,
                additionalInfo: ""
            ))
        }
    }
        
    static func read() -> [UserClass] {
        return users
    }
}
