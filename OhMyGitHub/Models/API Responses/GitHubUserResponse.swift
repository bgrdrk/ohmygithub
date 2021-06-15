import Foundation

struct GitHubUser: Codable {
    let name: String
    let login: String
    let avatarUrl: String
    let followers: Int
    let following: Int
    let publicRepos: Int
    let starredUrl: String
}
