//
//  ApiClient.swift
//  users
//
//  Created by User on 17.11.2022.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

class ApiClient {
    
    let baseUrl = "https://randomuser.me/api/"

    
    func request<T>(apiMethod: String, httpMethod: HttpMethod, parametrs: [String: String]?, headers: [String:String]?, success: @escaping (T) -> Void, failure: ((Error) -> Void)?) where T: Codable {
    
        var urlRequest = URLRequest(url: URL(string: baseUrl + apiMethod)!)
        if let headers = headers {
            for (k, v) in headers {
                urlRequest.setValue(v, forHTTPHeaderField: k)
            }
        }
        if let params = parametrs {
            print("failed to get parametrs")
            guard let jsonFromParams = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else {
                print("failed to serialize data to json")
                return
            }
            urlRequest.httpBody = jsonFromParams
        }        
        urlRequest.httpMethod = httpMethod.rawValue
        
        let session = URLSession.shared
        // error in parametrs means that request isn't call
        session.dataTask(with: urlRequest) { data, response, _ in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                guard let data = data else {
                    print("failed to get data of Url session")
                    return
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                do {
                    let result = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        success(result)
                    }
                } catch {
                  print(error)
                }
            }
        }.resume()
    }
    
    static func downloadUserImage(_ userPhoto: String, completition: @escaping (Data) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: URL(string: userPhoto)!) { data, error, _ in
            guard let data = data else {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                completition(data)
            }
        }.resume()
    }
}
