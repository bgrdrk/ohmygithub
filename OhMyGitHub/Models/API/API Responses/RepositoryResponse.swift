import Foundation

struct Repository: Codable {
    let name: String
    let description: String
    let owner: Owner
    let stargazersCount: Int
    let contributorsUrl: String
    let language: String?
}
