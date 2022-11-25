//
//  DownloadUsers.swift
//  users
//
//  Created by User on 17.11.2022.
//

import Foundation

class DownloadUsers {
    static func downloadUsers(amountOfUsers: Int, comletition: @escaping (Users) -> Void) {
        let client = ApiClient()
        client.request(apiMethod: "?results=\(amountOfUsers)", httpMethod: .get, parametrs: nil, headers: nil, success: { results in
            comletition(results)
        }, failure: nil)
    }
}
