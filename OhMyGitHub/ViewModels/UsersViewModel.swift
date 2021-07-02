import Foundation

class UsersViewModel {
    let networkManager: NetworkManager!
    
    private(set) var accounts = Observable([GitHubAccount]())
    
    init(accounts: [GitHubAccount], networkManager: NetworkManager)
    {
        self.accounts.value = accounts
        self.networkManager = networkManager
    }
    
    func start() {
        
    }
    
    
    // MARK: - Helpers
    
}
