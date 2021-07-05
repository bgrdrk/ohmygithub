import Foundation

protocol Endpoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    
    var urlString: String {
        return baseURLString + path
    }
    
    var urlWithComponents: URL {
        var urlComponent = URLComponents(string: urlString)!
        guard let query = self.query else { return urlComponent.url! }
        var queryItems = urlComponent.queryItems ?? []
        query.forEach({ item in
            queryItems.append(URLQueryItem(name: item.key, value: item.value))
        })
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
    
    func setHeadersAndAccessToken(_ urlRequest: URLRequest, accessToken: String?) -> URLRequest {
        var urlRequest = urlRequest
        self.headers?.forEach { header in
            if header.key == "Authorization", let accessToken = accessToken {
                urlRequest.setValue(header.value.appending(accessToken), forHTTPHeaderField: header.key)
            } else {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        return urlRequest
    }
}
