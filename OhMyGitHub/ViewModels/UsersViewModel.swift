import Foundation

class UsersViewModel {
    private(set) var accounts = Observable([GitHubAccount]())
    private(set) var networkManager: NetworkManager
    
    init(accounts: [GitHubAccount], networkManager: NetworkManager)
    {
        self.accounts.value = accounts
        self.networkManager = networkManager
    }
    
    // TODO: Refactor here
    func start() {
        
    }
}
