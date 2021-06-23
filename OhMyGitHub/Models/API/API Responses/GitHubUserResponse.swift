import Foundation

// TODO: GitHubUser should be an Owner probably. Just like Organization.
struct GitHubUser: Codable {
    let name: String
    let login: String
    let avatarUrl: String
    let followers: Int
    let followersUrl: String
    let following: Int
    let followingUrl: String
    let publicRepos: Int
    let reposUrl: String
    let starredUrl: String
}
