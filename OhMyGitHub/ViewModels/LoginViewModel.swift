import Foundation

class LoginViewModel {
    private let appSessionManager: AppSessionManager!
    private let networkManager: NetworkManager!
    
    var onError: ((String?) -> Void)?
    var onLogin: (() -> Void)?
    
    init(appSessionManager: AppSessionManager, networkManager: NetworkManager)
    {
        self.appSessionManager = appSessionManager
        self.networkManager = networkManager
    }
}

    // MARK: - Network calls

extension LoginViewModel {
    
    func getAccessTokenAndContinueAuth(using code: String) {
        let getAccessEndpoint = EndpointCases.getAccessToken(code: code)
        self.networkManager.getAccessToken(endpoint: getAccessEndpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let accessTokenData):
                self.appSessionManager.saveTokenData(accessTokenData)
                self.fetchLoggedInUserData()
            }
        }
    }
    
    private func fetchLoggedInUserData() {
        let endpoint = EndpointCases.getUser(token: appSessionManager.token!.accessToken)
        networkManager.getGitHubUser(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let gitHubUserData):
                self.appSessionManager.saveUserData(gitHubUserData)
                DispatchQueue.main.async {
                    self.onLogin!()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func getQueryStringParameter(url: URL, param: String) -> String? {
        guard let url = URLComponents(string: url.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

