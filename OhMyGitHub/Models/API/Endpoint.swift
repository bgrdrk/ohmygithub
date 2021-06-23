import Foundation

protocol Endpoint {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    
    var urlString: String {
        return baseURLString + path
    }
    
    var urlWithComponents: URL {
        var urlComponent = URLComponents(string: urlString)!
        var queryItems = urlComponent.queryItems ?? []
        self.query?.forEach({ item in
            queryItems.append(URLQueryItem(name: item.key, value: item.value))
        })
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
}
