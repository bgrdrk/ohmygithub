enum EndpointCases: Endpoint {
    
    case authorization
    case getAccessToken(code: String)
    case getUser(token: String)
    case getPublicUser(login: String)
    case getUsersPublicRepos(login: String)
    case getUsersStarredRepos(login: String)
    case getUsersFollowers(login: String)
    case getUsersFollowedAccounts(login: String)
    case getRepositoryContributors(userName: String,
                                   repoName: String)
    
    case followUser(login: String, token: String)
    case unfollowUser(login: String, token: String)
    case checkIfAppUserFollowsUserWith(login: String, appUser: String)

    var httpMethod: String {
        switch self {
        case .authorization,
             .getUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .checkIfAppUserFollowsUserWith:
            return "GET"
        case .getAccessToken:
            return "POST"
        case .followUser:
            return "PUT"
        case .unfollowUser:
            return "DELETE"
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
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .followUser,
             .unfollowUser,
             .checkIfAppUserFollowsUserWith:
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
        case .getRepositoryContributors(let userName, let repoName):
            return "repos/\(userName)/\(repoName)/contributors"
        case .followUser(let login, _),
             .unfollowUser(let login, _):
            return "user/following/\(login)"
        case .checkIfAppUserFollowsUserWith(let login, let appUser):
            return "users/\(appUser)/following/\(login)"
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
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .checkIfAppUserFollowsUserWith:
            return ["Accept": "application/vnd.github.v3+json"]
        case .followUser(_, let token),
             .unfollowUser(_, let token):
            return ["Accept": "application/vnd.github.v3+json",
                    "Authorization": "token \(token)"]
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
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .followUser,
             .unfollowUser,
             .checkIfAppUserFollowsUserWith:
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
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .followUser,
             .unfollowUser,
             .checkIfAppUserFollowsUserWith:
            return nil
        }
    }
}
