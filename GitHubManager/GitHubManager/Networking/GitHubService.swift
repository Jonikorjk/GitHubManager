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
    case getLanguagesOfRepository(owner: String, repo: String)
    case removeRepositoryOfCurrentUser(owner: String, repo: String)
    case getListGitIgnoreTemplates
    case getCommonLicenses
    case createRepository(name: String, description: String, private: Bool, gitignoreTemplate: String, licenseTemplate: String, autoInit: Bool)
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
        case .getRepositoriesOfCurrentUser, .createRepository:
            return "/user/repos"
        case .getLanguagesOfRepository(let owner, let repo):
            return "/repos/\(owner)/\(repo)/languages"
        case .removeRepositoryOfCurrentUser(let owner, let repo):
            return "/repos/\(owner)/\(repo)"
        case .getListGitIgnoreTemplates:
            return "/gitignore/templates"
        case .getCommonLicenses:
            return "/licenses"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .isUserInGitHubSystem(_), .getUser, .getRepositoriesOfCurrentUser, .getLanguagesOfRepository(_,_), .getListGitIgnoreTemplates, .getCommonLicenses:
            return .get
        case .removeRepositoryOfCurrentUser(_, _):
            return .delete
        case .createRepository:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .isUserInGitHubSystem(_), .getUser, .getRepositoriesOfCurrentUser, .getLanguagesOfRepository(_,_), .removeRepositoryOfCurrentUser(_, _), .getListGitIgnoreTemplates, .getCommonLicenses:
            return .requestPlain
        case .createRepository(let name, let description, let isPrivate, let gitIgnoreTemplate, let licenseTemplate, let isReadMeExist):
            return .requestParameters(parameters: [
                "name": name,
                "description": description,
                "private": isPrivate,
                "gitignore_template": gitIgnoreTemplate,
                "license_template": licenseTemplate,
                "auto_init": isReadMeExist
            ], encoding: JSONEncoding.default)
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
        case .getLanguagesOfRepository(_, _):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)",
                "X-GitHub-Api-Version": "2022-11-28"]
        case .removeRepositoryOfCurrentUser(_, _):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)",
                "X-GitHub-Api-Version": "2022-11-28"]
        case .getListGitIgnoreTemplates:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)",
                "X-GitHub-Api-Version": "2022-11-28"]
        case .getCommonLicenses:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)",
                "X-GitHub-Api-Version": "2022-11-28"]
        case .createRepository:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(GitHubService.token)",
                "X-GitHub-Api-Version": "2022-11-28"]
        }
    }
}
