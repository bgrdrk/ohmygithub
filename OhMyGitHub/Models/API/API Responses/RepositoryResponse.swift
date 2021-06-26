import Foundation

struct Repository: Codable {
    let name: String
    let description: String?
    let owner: GitHubAccount
    let stargazersCount: Int
    let contributorsUrl: String
    let language: String?
}
