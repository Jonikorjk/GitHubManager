//
//  Routes.swift
//  GitHubManager
//
//  Created by User on 05.12.2022.
//

import Moya

enum GitHubService {
    case isUserInGitHubSystem(token: String)
    case getUser
    case getRepositoriesOfCurrentUser
}

extension GitHubService: TargetType {
    
    static var token: String = ""
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .isUserInGitHubSystem(_), .getUser:
            return "/user"
        case .getRepositoriesOfCurrentUser:
            return "/user/repos"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .isUserInGitHubSystem(_), .getUser, .getRepositoriesOfCurrentUser:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .isUserInGitHubSystem(_), .getUser, .getRepositoriesOfCurrentUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .isUserInGitHubSystem(let token):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)"]
        case .getUser:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)"]
        case .getRepositoriesOfCurrentUser:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)",
                "X-GitHub-Api-Version": "2022-11-28"]
        }
    }
    
    
}

