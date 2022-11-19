//
//  ApiClient.swift
//  users
//
//  Created by User on 17.11.2022.
//

import Foundation

enum HttpMethod: String {
    case get
    case post
    case delete
    case put
    case patch
}

class ApiClient {
    
    let baseUrl = "https://randomuser.me/api/"
    
    func request(apiMethod: String,  completition: @escaping (Users) -> Void) {
        let modifiedBaseUrl = baseUrl + apiMethod
        guard let url = URL(string: modifiedBaseUrl) else {
            print("failed to get users")
            return
        }
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("lox")
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            guard let parsedData = try? decoder.decode(Users.self, from: data) else {
                print("failed to parse json")
                return
            }
            completition(parsedData)
        }.resume()
    }
}
