enum EndpointCases: Endpoint {
    
    case authorization
    case getAccessToken(code: String)
    case getUser(token: String)
    case getPublicUser(login: String)
    case getUsersPublicRepos(login: String)
    case getUsersStarredRepos(login: String)
    case getUsersFollowers(login: String)
    case getUsersFollowedAccounts(login: String)

    var httpMethod: String {
        switch self {
        case .authorization,
             .getUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
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
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
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
        case .getPublicUser(let login):
            return "users/\(login)"
        case .getUsersPublicRepos(let login):
            return "users/\(login)/repos"
        case .getUsersStarredRepos(let login):
            return "users/\(login)/starred"
        case .getUsersFollowers(let login):
            return "users/\(login)/followers"
        case .getUsersFollowedAccounts(let login):
            return "users/\(login)/following"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .authorization,
             .getAccessToken,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
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
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowedAccounts,
             .getUsersFollowers:
            return nil
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .authorization,
             .getAccessToken,
             .getUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts:
            return nil
        }
    }
}
