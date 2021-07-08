import Foundation

class LoginViewModel {
    private let appSessionManager: AppSessionManager!
    private let networkManager: NetworkManager!
    
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
        self.networkManager.getAccessTokenAndFetchAppUserData(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let authorizedUserData):
                self.appSessionManager.saveUserData(authorizedUserData)
                DispatchQueue.main.async {
                    self.onLogin?()
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

