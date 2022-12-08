//
//  License.swift
//  GitHubManager
//
//  Created by User on 08.12.2022.
//

import Foundation

//"key": "mit",
// "name": "MIT License",
// "spdx_id": "MIT",
// "url": "https://api.github.com/licenses/mit",
// "node_id": "MDc6TGljZW5zZW1pdA=="


struct License: Codable {
    var name: String
    var key: String
    var spdxId: String
    var url: String
    var nodeId: String
    
    enum CodingKeys: String, CodingKey {
        case name, key, url
        case nodeId = "node_id"
        case spdxId = "spdx_id"
    }
}
