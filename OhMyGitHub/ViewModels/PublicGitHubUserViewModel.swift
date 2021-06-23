import Foundation

class PublicGitHubUserViewModel {
    private let networkManager: NetworkManager!
    private let account: GitHubAccount!
    
    var user = Observable<PublicGitHubUser?>(nil)
    var followers = Observable([GitHubAccount]())
    var following = Observable([GitHubAccount]())
    
    var onError: ((String?) -> Void)?
    var onShowLogin: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    init(account: GitHubAccount, networkManager: NetworkManager)
    {
        self.account = account
        self.networkManager = networkManager
    }
    
    func start() {
        fetchUserData()
    }
}

    // MARK: - Netwark calls

private extension PublicGitHubUserViewModel {
    
    func fetchUserData() {
        let endpoint = EndpointCases.getPublicUser(login: account.login)
        networkManager.getPublicGitHubUser(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let user):
                self.user.value = user
            }
        }
    }
    
}
