import Foundation

final class NetworkManager {
    
    enum Method: String { case get, post, put, delete }
    
    // MARK: - Properties
    
    let persistanceManager: PersistanceCoordinator!
    private var accessToken: String!
    
    init (persistanceManager: PersistanceCoordinator) {
        self.persistanceManager = persistanceManager
        loadTokenData()
    }
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    private let decoder = JSONDecoder()
    
    // MARK: - Helpers
    
    private func loadTokenData() {
        guard let tokenData: AccessTokenResponse = try? persistanceManager.load(title: "Token Data") else {
            return
        }
        accessToken = tokenData.accessToken
    }
    
    func saveTokenData(_ tokenData: AccessTokenResponse) {
        persistanceManager.save(tokenData, title: "Token Data")
        accessToken = tokenData.accessToken
    }
    
    private func makeRequest(_ endpoint: Endpoint) -> URLRequest {
        let url = endpoint.urlWithComponents
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod
        urlRequest = endpoint.setHeadersAndAccessToken(urlRequest, accessToken: accessToken)
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
    
    func getAccessTokenAndFetchAppUserData(with code: String, _ completion: @escaping (Result<PublicGitHubUser, AppError>) -> ()) {
        let endpoint = EndpointCases.getAccessToken(code: code)
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request) { [weak self] (result: Result<AccessTokenResponse, AppError>) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                completion(.failure(error))
            case .success(let accessTokenResponse):
                self.accessToken = accessTokenResponse.accessToken
                self.saveTokenData(accessTokenResponse)
                self.getAppUser(completion)
            }
        }
        dataTask.resume()
    }
    
    private func getAppUser(_ completion: @escaping (Result<PublicGitHubUser, AppError>) -> ()) {
        let endpoint = EndpointCases.getAuthorizedUser
        let request = makeRequest(endpoint)
        let dataTask = makeDataTask(with: request, completion: completion)
        dataTask.resume()
    }
    
    func getGitHubUser(with loginName: String, _ completion: @escaping (Result<PublicGitHubUser, AppError>) -> ()) {
        let endpoint = EndpointCases.getPublicUser(login: loginName)
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
    
    func getFollowers(of userName: String, _ completion: @escaping (Result<[GitHubAccount], AppError>) -> ()) {
        let endpoint = EndpointCases.getUsersFollowers(login: userName)
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
    
    func downloadImageData(urlString: String,  _ completion: @escaping (Result<Data, AppError>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let imageData = data else { return }
            completion(.success(imageData))
        }
        task.resume()
    }
}
