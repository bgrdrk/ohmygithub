import Foundation

class UsersViewModel {
    private(set) var accounts: [GitHubAccount]
    private(set) var sortedAccounts = Observable([GitHubAccount]())
    private(set) var networkManager: NetworkManager
    
    init(accounts: [GitHubAccount], networkManager: NetworkManager)
    {
        self.accounts = accounts
        self.networkManager = networkManager
    }
    
    // TODO: Refactor here
    func start() {
        sortAccountsByUsernameAscending()
    }
    
    func sortAccountsByUsernameAscending() {
        sortedAccounts.value = accounts.sorted { $0.login.lowercased() < $1.login.lowercased() }
    }
    
    func sortAccountsByUsernameDescending() {
        sortedAccounts.value = accounts.sorted { $0.login.lowercased() > $1.login.lowercased() }
    }
}
