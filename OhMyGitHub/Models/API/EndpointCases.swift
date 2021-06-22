enum EndpointCases: Endpoint {
    
    case authorization
    case getAccessToken(code: String)
    
    var httpMethod: String {
        switch self {
        case .authorization:
            return "GET"
        case .getAccessToken:
            return "POST"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .authorization,
             .getAccessToken:
            return "https://github.com/login/oauth/"
        }
    }
    
    var path: String {
        switch self {
        case .authorization:
            return "authorize"
        case .getAccessToken:
            return "access_token"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .authorization:
            return ["Accept": "application/vnd.github.v3+json",
                    "client_id": Secrets.clientId]
        case .getAccessToken:
            return ["Accept": "application/vnd.github.v3+json"]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .authorization:
            return nil
        case .getAccessToken(let code):
            return ["client_id": Secrets.clientId,
                    "client_secret": Secrets.clientSecret,
                    "code": code]
        }
    }
}
