//
//  .swift
import Foundation

class AppUserViewModel {
    private let appSessionManager: AppSessionManager!
    private let networkManager: NetworkManager!
    
    var appUser = Observable<PublicGitHubUser?>(nil)
    var followers = Observable([GitHubAccount]())
    var following = Observable([GitHubAccount]())
    var publicRepos = Observable([Repository]())
    var starredRepos = Observable([Repository]())
    
    var onError: ((String?) -> Void)?
    var onShowLogin: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    init(appSessionManager: AppSessionManager, networkManager: NetworkManager)
    {
        self.appSessionManager = appSessionManager
        self.networkManager = networkManager
    }
    
    func start() {
        appUser.value = appSessionManager.appUser
        fetchFollowers()
        fetchFollowedAccounts()
        fetchUsersPublicRepos()
        fetchStarredRepos()
    }
    
    // MARK: - Helpers
    
    func logUserOut() {
        appSessionManager.logUserOut()
    }

}

    // MARK: - Netwark calls

private extension AppUserViewModel {
    
    func fetchFollowers() {
        guard let userLogin = appSessionManager.appUser?.login else {
            // TODO: Handle error swiftly
            print("DEBUG: appUser in session manager is nil. This must not happen here")
            return
        }
        let endpoint = EndpointCases.getUsersFollowers(login: userLogin)
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
        guard let userLogin = appSessionManager.appUser?.login else {
            // TODO: Handle error swiftly
            print("DEBUG: appUser in session manager is nil. This must not happen here")
            return
        }
        let endpoint = EndpointCases.getUsersFollowedAccounts(login: userLogin)
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
        guard let userLogin = appSessionManager.appUser?.login else {
            // TODO: Handle error swiftly
            print("DEBUG: appUser in session manager is nil. This must not happen here")
            return
        }
        let endpoint = EndpointCases.getUsersPublicRepos(login: userLogin)
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
        let userLogin = appSessionManager.appUser?.login
        let endpoint = EndpointCases.getUsersStarredRepos(login: userLogin!)
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

