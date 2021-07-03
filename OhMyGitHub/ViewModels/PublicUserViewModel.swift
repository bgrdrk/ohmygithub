import Foundation

class PublicUserViewModel {
    private let networkManager: NetworkManager!
    private let appSessionManager: AppSessionManager!
    
    private(set) var account = Observable<GitHubAccount?>(nil)
    private(set) var user = Observable<PublicGitHubUser?>(nil)
    private(set) var followers = Observable([GitHubAccount]())
    private(set) var following = Observable([GitHubAccount]())
    private(set) var publicRepos = Observable([Repository]())
    private(set) var starredRepos = Observable([Repository]())
    private(set) var presentedUserIsFolloweByAppUser = Observable(false)
    
    var onError: ((String?) -> Void)?
    var onUserIsAppUser: ((Bool) -> Void)?
    var onDismiss: (() -> Void)?
    
    init(account: GitHubAccount, networkManager: NetworkManager, appSessionManager: AppSessionManager)
    {
        self.account.value = account
        self.networkManager = networkManager
        self.appSessionManager = appSessionManager
    }
    
    func start() {
        checkIfPresentedUserIsAppUser()
        fetchUserData()
        fetchFollowers()
        fetchFollowedAccounts()
        fetchUsersPublicRepos()
        fetchStarredRepos()
        checkIfAppUserFollowsPresentedUser()
    }
    
    // MARK: - Helpers
    
    private func checkIfPresentedUserIsAppUser() {
        if account.value?.login == appSessionManager.appUser?.login {
            onUserIsAppUser?(true)            
        }
    }
}

    // MARK: - Netwark calls

extension PublicUserViewModel {
    
    private func fetchUserData() {
        guard let account  = account.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Account must not be nil here")
            return
        }
        let endpoint = EndpointCases.getPublicUser(login: account.login)
        networkManager.getGitHubUser(endpoint) { [weak self] result in
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
    
    private func fetchFollowers() {
        guard let account  = account.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Account must not be nil here")
            return
        }
        networkManager.getFollowers(of: account.login) { [weak self] result in
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
        guard let account  = account.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Account must not be nil here")
            return
        }
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
        guard let account  = account.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Account must not be nil here")
            return
        }
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
        guard let account  = account.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Account must not be nil here")
            return
        }
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
    
    func followUnfollowUser() {
        guard let userLogin = account.value?.login.lowercased() else { return }
        
        let endpoint: Endpoint
        if presentedUserIsFolloweByAppUser.value {
            endpoint = EndpointCases.unfollowUser(login: userLogin)
        } else {
            endpoint = EndpointCases.followUser(login: userLogin)
        }
        presentedUserIsFolloweByAppUser.value.toggle()
        
        networkManager.toggleFollowingUser(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let statusCode):
                print(statusCode)
            }
        }
    }
    
    private func checkIfAppUserFollowsPresentedUser() {
        guard let userLogin = account.value?.login.lowercased(),
              let appUserLogin = appSessionManager.appUser?.login.lowercased() else { return }
        let endpoint = EndpointCases.checkIfAppUserFollowsUserWith(login: userLogin, appUser: appUserLogin)
        networkManager.checkIfAppUserFollowsAnotherUser(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let statusCode):
                self.presentedUserIsFolloweByAppUser.value = statusCode == 204
            }
        }
    }
}
