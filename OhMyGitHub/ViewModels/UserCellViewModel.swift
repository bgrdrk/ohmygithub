import UIKit

class UserCellViewModel {
    private let networkManager: NetworkManager!
    
    var account: GitHubAccount
    var user = Observable<PublicGitHubUser?>(nil)
    var profileImage = Observable(UIImage())
    var username = Observable("")
    var followers = Observable(Int(0))
    
    init(networkManager: NetworkManager, account: GitHubAccount) {
        self.networkManager = networkManager
        self.account = account
    }
    
    func start() {
        setProfileImage()
        setFollowersCount()
        username.value = account.login
    }
    
    private func setProfileImage() {
        
        let imageCacheKey = NSString(string: account.avatarUrl)
        if let image = networkManager.persistanceManager.cache.object(forKey: imageCacheKey) {
            self.profileImage.value = image.roundedImage
            return
        }
        
        networkManager.downloadImageData(urlString: account.avatarUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let imageData):
                guard let compressedImage = UIImage(data: imageData)?.compressedImage else { return }
                self.networkManager.persistanceManager.cache.setObject(compressedImage, forKey: imageCacheKey)
                DispatchQueue.main.async {
                    self.profileImage.value = compressedImage.roundedImage
                }
            }
        }
    }
    
    private func setFollowersCount() {
        
        if let loadedUser = try? networkManager.persistanceManager.load(title: account.login) as PublicGitHubUser {
            user.value = loadedUser
            followers.value = loadedUser.followers
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
                self.followers.value = user.followers
                self.networkManager.persistanceManager.save(user, title: user.login)
            }
        }
    }
}