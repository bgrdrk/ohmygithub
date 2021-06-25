import Foundation

class PublicUserViewModel {
    private let networkManager: NetworkManager!
    private let account: GitHubAccount!
    
    private(set) var user = Observable<PublicGitHubUser?>(nil)
    private(set) var followers = Observable([GitHubAccount]())
    private(set) var following = Observable([GitHubAccount]())
    private(set) var publicRepos = Observable([Repository]())
    private(set) var starredRepos = Observable([Repository]())
    
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
        fetchFollowers()
        fetchFollowedAccounts()
        fetchStarredRepos()
        fetchStarredRepos()
    }
}

    // MARK: - Netwark calls

private extension PublicUserViewModel {
    
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
    
    func fetchFollowers() {
        let endpoint = EndpointCases.getUsersFollowers(login: account.login)
        networkManager.getFollowers(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let followers):
                self.followers.value = followers
            }
        }
    }
    
    private func fetchFollowedAccounts() {
        let endpoint = EndpointCases.getUsersFollowedAccounts(login: account.login)
        networkManager.getFollowedAccounts(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let followedAccounts):
                self.following.value = followedAccounts
            }
        }
    }
    
    private func fetchUsersPublicRepos() {
        let endpoint = EndpointCases.getUsersPublicRepos(login: account.login)
        networkManager.getUsersRepos(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let repos):
                self.publicRepos.value = repos
            }
        }
    }
    
    private func fetchStarredRepos() {
        let endpoint = EndpointCases.getUsersStarredRepos(login: account.login)
        networkManager.getUsersRepos(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let repos):
                self.starredRepos.value = repos
            }
        }
    }
}
