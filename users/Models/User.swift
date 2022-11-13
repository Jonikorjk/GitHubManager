//
//  User.swift
//  users
//
//  Created by User on 10.11.2022.
//

import Foundation

struct User: Codable {
    struct Name: Codable
    {
        var first: String
        var last: String
    }
    
    struct Location: Codable
    {
        
        struct Street : Codable
        {
            var fullName: String {
                return name + " " + String(number)
            }
            var number: Int
            var name: String
        }
    
        var street: Street
        var city: String
        var country: String
    }
    
    struct Login: Codable
    {
        var username: String
        var password: String
    }
    
    struct DateOfBirthday: Codable
    {
        var date: Date
        var age: Int
    }
    
    struct Picture: Codable
    {
        var large: String
        var medium: String
    }
    
    var gender: String
    var name: Name
    var location: Location
    var email: String
    var login: Login
    var dob: DateOfBirthday
    var phone: String
    var picture: Picture
}

struct Users: Codable {
    var results: [User]
}

