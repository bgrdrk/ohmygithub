enum EndpointCases: Endpoint {
    
    case authorization
    case getAccessToken(code: String)
    case getUser(token: String)
    case getUsersStarredRepos(login: String)
    case getUsersFollowedAccounts(login: String)
    
    var httpMethod: String {
        switch self {
        case .authorization,
             .getUser,
             .getUsersStarredRepos,
             .getUsersFollowedAccounts:
            return "GET"
        case .getAccessToken:
            return "POST"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .authorization, .getAccessToken:
            return "https://github.com/login/oauth/"
        case .getUser,
             .getUsersStarredRepos,
             .getUsersFollowedAccounts:
            return "https://api.github.com/"
        }
    }
    
    var path: String {
        switch self {
        case .authorization:
            return "authorize"
        case .getAccessToken:
            return "access_token"
        case .getUser:
            return "user"
        case .getUsersStarredRepos(let login):
            return "users/\(login)/starred"
        case .getUsersFollowedAccounts(let login):
            return "users/\(login)/following"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .authorization,
             .getAccessToken,
             .getUsersStarredRepos,
             .getUsersFollowedAccounts:
            return ["Accept": "application/vnd.github.v3+json"]
        case .getUser(let token):
            return ["Accept": "application/vnd.github.v3+json",
                    "Authorization": "token \(token)"]
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .authorization:
            return ["client_id": Secrets.clientId]
        case .getAccessToken(let code):
            return ["client_id": Secrets.clientId,
                    "client_secret": Secrets.clientSecret,
                    "code": code]
        case .getUser,
             .getUsersStarredRepos,
             .getUsersFollowedAccounts:
            return nil
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .authorization,
             .getAccessToken,
             .getUser,
             .getUsersStarredRepos,
             .getUsersFollowedAccounts:
            return nil
        }
    }
}
