import Foundation

final class NetworkManager {
    
    enum Method: String { case get, post, put, delete }
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    private init () {}
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    private let decoder = JSONDecoder()
    
    // MARK: - Helpers
    
    func makeRequestAndDataTask<T: Codable>(with url: URL,
                                  method: Method,
                                  completion: @escaping (Result<T, AppError>) -> ()
    ) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("secret-keyValue", forHTTPHeaderField: "secret-key")
        
        if method == .post {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.firstError))
                return
            }

            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let decodedData = try? self.decoder.decode(T.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }

            completion(.success(decodedData))
        }
        return dataTask
    }
    
    // MARK: - GET tasks
    
    func getAccessToken(_ url: URL, _ completion: @escaping (Result<AccessTokenResponse, AppError>) -> ()) {
        let dataTask = makeRequestAndDataTask(with: url, method: .post, completion: completion)
        dataTask.resume()
    }
    
    func getGitHubUser(token: String, _ completion: @escaping (Result<GitHubUser, AppError>) -> ()) {
        
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.httpMethod = Method.get.rawValue
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.firstError))
                return
            }

            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let decodedData = try? self.decoder.decode(GitHubUser.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }

            completion(.success(decodedData))
        }
        dataTask.resume()
    }
}
