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
    
    private func makeRequest(_ endpoint: Endpoint) -> URLRequest {
        let url = endpoint.urlWithComponents
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod
        urlRequest = endpoint.setHeaders(urlRequest)
        return urlRequest
    }
    
    private func makeDataTask<T: Codable>(with request: URLRequest,
                                          completion: @escaping (Result<T, AppError>) -> ()
    ) -> URLSessionDataTask {
        
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
    
    private func makeDataTaskWithNoBodyComingBack(with request: URLRequest,
                                                  completion: @escaping (Result<Int, AppError>) -> ()
    ) -> URLSessionDataTask {
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            guard let _ = data else {
                // TODO: Handle error which comes back with data.
                // it happens when token is expired, etc...
                completion(.failure(.firstError))
                print("Error, there should be no data...")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.firstError))
                print("There must always be a response...")
                return
            }
            
            completion(.success(httpResponse.statusCode))
        }
        return dataTask
    }
    
    // MARK: - GET tasks
    
    func getAccessToken(endpoint: Endpoint, _ completion: @escaping (Result<AccessTokenResponse, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getGitHubUser(_ endpoint: Endpoint, _ completion: @escaping (Result<PublicGitHubUser, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getPublicGitHubUser(_ endpoint: Endpoint, _ completion: @escaping (Result<PublicGitHubUser, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getUsersRepos(_ endpoint: Endpoint, _ completion: @escaping (Result<[Repository], AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getFollowedAccounts(_ endpoint: Endpoint, _ completion: @escaping (Result<[GitHubAccount], AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getFollowers(_ endpoint: Endpoint, _ completion: @escaping (Result<[GitHubAccount], AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getRepositoryContributors(_ endpoint: Endpoint, _ completion: @escaping (Result<[GitHubAccount], AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func toggleFollowingUser(_ endpoint: Endpoint, _ completion: @escaping (Result<Int, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTaskWithNoBodyComingBack(with: request, completion: completion)
        dataTask.resume()
    }
    
    func checkIfAppUserFollowsAnotherUser(_ endpoint: Endpoint, _ completion: @escaping (Result<Int, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTaskWithNoBodyComingBack(with: request, completion: completion)
        dataTask.resume()
    }
    
    func toggleRepositoryStar(_ endpoint: Endpoint, _ completion: @escaping (Result<Int, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTaskWithNoBodyComingBack(with: request, completion: completion)
        dataTask.resume()
    }
    
    func checkIfAppUserStarredThisRepository(_ endpoint: Endpoint, _ completion: @escaping (Result<Int, AppError>) -> ()) {
        let request = makeRequest(endpoint)
        let dataTask = makeDataTaskWithNoBodyComingBack(with: request, completion: completion)
        dataTask.resume()
    }
}
