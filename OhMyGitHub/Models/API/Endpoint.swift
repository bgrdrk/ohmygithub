import Foundation

protocol Endpoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    
    var url: String {
        return baseURLString + path
    }
    
    var urlWithHeaders: URL {
        var urlComponent = URLComponents(string: url)!
        var queryItems = urlComponent.queryItems ?? []
        self.headers?.forEach({ header in
            queryItems.append(URLQueryItem(name: header.key, value: header.value))
        })
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
}
