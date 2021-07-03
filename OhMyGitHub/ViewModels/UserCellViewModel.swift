import UIKit

class UserCellViewModel {
    private let networkManager: NetworkManager!
    
    var account: GitHubAccount
    var profileImage = Observable(UIImage())
    var username = Observable("")
    var followers = Observable(Int(0))
    
    init(networkManager: NetworkManager, account: GitHubAccount) {
        self.account = account
        self.networkManager = networkManager
    }
    
    func start() {
        setProfileImage()
        setFollowersCount()
        username.value = account.login
    }
    
    private func setProfileImage() {
        networkManager.downloadImageData(urlString: account.avatarUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                DispatchQueue.main.async {
                    self.profileImage.value = image
                }
            }
        }
    }
    
    private func setFollowersCount() {
        followers.value = 12345
//        let endpoint = EndpointCases.getPublicUser(login: account.login)
//        networkManager.getGitHubUser(endpoint) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .failure(let error):
//                // TODO: Handle error swiftly
//                print("DEBUG: error -> \(error.description)")
//            case .success(let user):
//                self.followers.value = user.followers
//            }
//        }
    }
}
