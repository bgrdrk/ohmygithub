import UIKit

class PublicUserViewModel {
    private let networkManager: NetworkManager!
    private let appSessionManager: AppSessionManager!
    
    private(set) var profileImage = Observable<UIImage>(UIImage(named: "github_avatar")!)
    private(set) var account = Observable<GitHubAccount?>(nil)
    private(set) var user = Observable<PublicGitHubUser?>(nil)
    private(set) var followers = Observable([GitHubAccount]())
    private(set) var following = Observable([GitHubAccount]())
    private(set) var publicRepos = Observable([Repository]())
    private(set) var starredRepos = Observable([Repository]())

    private(set) var dataFetchCounter = Observable(0)
    private(set) var presentedUserIsFolloweByAppUser = Observable<Bool?>(nil)
    
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
        setProfileImage()
        fetchUserData()
        fetchFollowers()
        fetchFollowedAccounts()
        fetchUsersPublicRepos()
        fetchStarredRepos()
        checkIfAppUserFollowsPresentedUser()
    }
    
    // MARK: - Helpers
    
    private func setProfileImage() {
        let imageCacheKey = NSString(string: account.value!.avatarUrl)
        if let image = networkManager.persistanceManager.cache.object(forKey: imageCacheKey) {
            self.profileImage.value = image.roundedImage
            self.dataFetchCounter.value += 1
        }
    }
    
    private func checkIfPresentedUserIsAppUser() {
        if account.value?.login == appSessionManager.appUser?.login {
            onUserIsAppUser?(true)            
        }
    }
}

    // MARK: - Network calls

extension PublicUserViewModel {
    
    private func fetchUserData() {

        guard let account  = account.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Account must not be nil here")
            return
        }
        
        if let loadedUser = try? networkManager.persistanceManager.load(title: account.login) as PublicGitHubUser {
            user.value = loadedUser
            return
        }
        
        networkManager.getGitHubUser(with: account.login) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let user):
                self.user.value = user
                self.dataFetchCounter.value += 1
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
                self.dataFetchCounter.value += 1
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
                self.dataFetchCounter.value += 1
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
                self.dataFetchCounter.value += 1
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
                self.dataFetchCounter.value += 1
            }
        }
    }
    
    func followUnfollowUser() {
        guard let userLogin = account.value?.login.lowercased() else { return }
        
        let endpoint: Endpoint
        if let _ = presentedUserIsFolloweByAppUser.value {
            endpoint = EndpointCases.unfollowUser(login: userLogin)
        } else {
            endpoint = EndpointCases.followUser(login: userLogin)
        }
        presentedUserIsFolloweByAppUser.value?.toggle()
        
        networkManager.toggleFollowingUser(endpoint) { result in
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
