//
//  Repository.swift
//  GitHubManager
//
//  Created by User on 06.12.2022.
//

import Foundation

//[
//  {
//    "id": 1296269,
//    "node_id": "MDEwOlJlcG9zaXRvcnkxMjk2MjY5",
//    "name": "Hello-World",
//    "full_name": "octocat/Hello-World",
//    "private": false,
//    "html_url": "https://github.com/octocat/Hello-World",
//    "description": "This your first repo!",
//    "fork": false,
//    "url": "https://api.github.com/repos/octocat/Hello-World",
//    "archive_url": "https://api.github.com/repos/octocat/Hello-World/{archive_format}{/ref}",
//    "assignees_url": "https://api.github.com/repos/octocat/Hello-World/assignees{/user}",
//    "blobs_url": "https://api.github.com/repos/octocat/Hello-World/git/blobs{/sha}",
//    "branches_url": "https://api.github.com/repos/octocat/Hello-World/branches{/branch}",
//    "collaborators_url": "https://api.github.com/repos/octocat/Hello-World/collaborators{/collaborator}",
//    "comments_url": "https://api.github.com/repos/octocat/Hello-World/comments{/number}",
//    "commits_url": "https://api.github.com/repos/octocat/Hello-World/commits{/sha}",
//    "compare_url": "https://api.github.com/repos/octocat/Hello-World/compare/{base}...{head}",
//    "contents_url": "https://api.github.com/repos/octocat/Hello-World/contents/{+path}",
//    "contributors_url": "https://api.github.com/repos/octocat/Hello-World/contributors",
//    "deployments_url": "https://api.github.com/repos/octocat/Hello-World/deployments",
//    "downloads_url": "https://api.github.com/repos/octocat/Hello-World/downloads",
//    "events_url": "https://api.github.com/repos/octocat/Hello-World/events",
//    "forks_url": "https://api.github.com/repos/octocat/Hello-World/forks",
//    "git_commits_url": "https://api.github.com/repos/octocat/Hello-World/git/commits{/sha}",
//    "git_refs_url": "https://api.github.com/repos/octocat/Hello-World/git/refs{/sha}",
//    "git_tags_url": "https://api.github.com/repos/octocat/Hello-World/git/tags{/sha}",
//    "git_url": "git:github.com/octocat/Hello-World.git",
//    "issue_comment_url": "https://api.github.com/repos/octocat/Hello-World/issues/comments{/number}",
//    "issue_events_url": "https://api.github.com/repos/octocat/Hello-World/issues/events{/number}",
//    "issues_url": "https://api.github.com/repos/octocat/Hello-World/issues{/number}",
//    "keys_url": "https://api.github.com/repos/octocat/Hello-World/keys{/key_id}",
//    "labels_url": "https://api.github.com/repos/octocat/Hello-World/labels{/name}",
//    "languages_url": "https://api.github.com/repos/octocat/Hello-World/languages",
//    "merges_url": "https://api.github.com/repos/octocat/Hello-World/merges",
//    "milestones_url": "https://api.github.com/repos/octocat/Hello-World/milestones{/number}",
//    "notifications_url": "https://api.github.com/repos/octocat/Hello-World/notifications{?since,all,participating}",
//    "pulls_url": "https://api.github.com/repos/octocat/Hello-World/pulls{/number}",
//    "releases_url": "https://api.github.com/repos/octocat/Hello-World/releases{/id}",
//    "ssh_url": "git@github.com:octocat/Hello-World.git",
//    "stargazers_url": "https://api.github.com/repos/octocat/Hello-World/stargazers",
//    "statuses_url": "https://api.github.com/repos/octocat/Hello-World/statuses/{sha}",
//    "subscribers_url": "https://api.github.com/repos/octocat/Hello-World/subscribers",
//    "subscription_url": "https://api.github.com/repos/octocat/Hello-World/subscription",
//    "tags_url": "https://api.github.com/repos/octocat/Hello-World/tags",
//    "teams_url": "https://api.github.com/repos/octocat/Hello-World/teams",
//    "trees_url": "https://api.github.com/repos/octocat/Hello-World/git/trees{/sha}",
//    "clone_url": "https://github.com/octocat/Hello-World.git",
//    "mirror_url": "git:git.example.com/octocat/Hello-World",
//    "hooks_url": "https://api.github.com/repos/octocat/Hello-World/hooks",
//    "svn_url": "https://svn.github.com/octocat/Hello-World",
//    "homepage": "https://github.com",
//    "language": null,
//    "forks_count": 9,
//    "stargazers_count": 80,
//    "watchers_count": 80,
//    "size": 108,
//    "default_branch": "master",
//    "open_issues_count": 0,
//    "is_template": true,
//    "topics": [
//      "octocat",
//      "atom",
//      "electron",
//      "api"
//    ],
//    "has_issues": true,
//    "has_projects": true,
//    "has_wiki": true,
//    "has_pages": false,
//    "has_downloads": true,
//    "archived": false,
//    "disabled": false,
//    "visibility": "public",
//    "pushed_at": "2011-01-26T19:06:43Z",
//    "created_at": "2011-01-26T19:01:12Z",
//    "updated_at": "2011-01-26T19:14:43Z",
//    "permissions": {
//      "admin": false,
//      "push": false,
//      "pull": true
//    },
//    "allow_rebase_merge": true,
//    "template_repository": null,
//    "temp_clone_token": "ABTLWHOULUVAXGTRYU7OC2876QJ2O",
//    "allow_squash_merge": true,
//    "allow_auto_merge": false,
//    "delete_branch_on_merge": true,
//    "allow_merge_commit": true,
//    "subscribers_count": 42,
//    "network_count": 0,
//    "license": {
//      "key": "mit",
//      "name": "MIT License",
//      "url": "https://api.github.com/licenses/mit",
//      "spdx_id": "MIT",
//      "node_id": "MDc6TGljZW5zZW1pdA==",
//      "html_url": "https://github.com/licenses/mit"
//    },
//    "forks": 1,
//    "open_issues": 1,
//    "watchers": 1
//  }
//]

struct Repository: Codable {
    var name: String
    var fullName: String
    var isPrivate: Bool
    var updateDate: Date?
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case updateDate = "updated_at"
        case language
    }
}
