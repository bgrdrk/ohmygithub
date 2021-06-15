import Foundation

struct AccessTokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    let tokenType: String
    let scope: String
}

//{
//  "access_token": "ghu_7GYhuRqqtv5cex1UtRDtzNs19vLysU0FB0nb",
//  "expires_in": 28800,
//  "refresh_token": "ghr_JYFf8YCQXilLIxOthdB5zbDzKnVuOqOgYFnzobanefHSy21qkBHIPjsPC9KGrh7yhCyRDq4DJJHR",
//  "refresh_token_expires_in": 15811200,
//  "token_type": "bearer",
//  "scope": ""
//}
