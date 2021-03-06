import Foundation

enum EndpointCases: Endpoint {
    
    case authorization
    case getAccessToken(code: String)
    case getAuthorizedUser
    case updateUser(_ userData: UpdatedUser)
    case getPublicUser(login: String)
    case getUsersPublicRepos(login: String)
    case getUsersStarredRepos(login: String)
    case getUsersFollowers(login: String)
    case getUsersFollowedAccounts(login: String)
    case getRepositoryContributors(userName: String,
                                   repoName: String)
    
    case followUser(login: String)
    case unfollowUser(login: String)
    case checkIfAppUserFollowsUserWith(login: String, appUser: String)
    
    case starRepository(login: String, repoName: String)
    case unstarRepository(login: String, repoName: String)
    case checkIfAppUserStarredThisRepository(login: String, repoName: String)

    var httpMethod: String {
        switch self {
        case .authorization,
             .getAuthorizedUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .checkIfAppUserFollowsUserWith,
             .checkIfAppUserStarredThisRepository:
            return "GET"
        case .getAccessToken:
            return "POST"
        case .followUser, .starRepository:
            return "PUT"
        case .unfollowUser, .unstarRepository:
            return "DELETE"
        case .updateUser:
            return "PATCH"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .authorization, .getAccessToken:
            return "https://github.com/login/oauth/"
        case .getAuthorizedUser,
             .updateUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .followUser,
             .unfollowUser,
             .checkIfAppUserFollowsUserWith,
             .starRepository,
             .unstarRepository,
             .checkIfAppUserStarredThisRepository:
            return "https://api.github.com/"
        }
    }
    
    var path: String {
        switch self {
        case .authorization:
            return "authorize"
        case .getAccessToken:
            return "access_token"
        case .getAuthorizedUser, .updateUser:
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
        case .followUser(let login),
             .unfollowUser(let login):
            return "user/following/\(login)"
        case .checkIfAppUserFollowsUserWith(let login, let appUser):
            return "users/\(appUser)/following/\(login)"
        case .starRepository(let login, let repoName),
             .unstarRepository(let login, let repoName),
             .checkIfAppUserStarredThisRepository(let login, let repoName):
            return "user/starred/\(login)/\(repoName)"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .authorization,
             .getAccessToken:
            return ["Accept": "application/vnd.github.v3+json"]
        case .updateUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .checkIfAppUserFollowsUserWith,
             .getAuthorizedUser,
             .followUser,
             .unfollowUser,
             .starRepository,
             .unstarRepository,
             .checkIfAppUserStarredThisRepository:
            return ["Accept": "application/vnd.github.v3+json",
                    "Content-Length": "0",
                    "Authorization": "token "]
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
        case .getAuthorizedUser,
             .updateUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .followUser,
             .unfollowUser,
             .checkIfAppUserFollowsUserWith,
             .starRepository, .unstarRepository,
             .checkIfAppUserStarredThisRepository:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .updateUser(let data):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let encodedData = try? encoder.encode(data)
            return encodedData
        case .authorization,
             .getAccessToken,
             .getAuthorizedUser,
             .getPublicUser,
             .getUsersPublicRepos,
             .getUsersStarredRepos,
             .getUsersFollowers,
             .getUsersFollowedAccounts,
             .getRepositoryContributors,
             .followUser,
             .unfollowUser,
             .checkIfAppUserFollowsUserWith,
             .starRepository, .unstarRepository,
             .checkIfAppUserStarredThisRepository:
            return nil
        }
    }
}
