import Foundation

struct AccessTokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    let tokenType: String
    let scope: String
}
