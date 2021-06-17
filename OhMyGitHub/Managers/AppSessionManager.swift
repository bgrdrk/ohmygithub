import Foundation

final class AppSessionManager {
    
    let persistanceManager: PersistanceManager!
    
    private(set) var token: AccessTokenResponse?
    private(set) var appUser: GitHubUser?
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
        loadUserData()
    }
    
    // MARK: - Helpers
    
    private func loadUserData() {
        guard let userData: GitHubUser = try? persistanceManager.load(title: "User Data") else {
            return
        }
        appUser = userData
    }
    
    func saveUserData(_ userData: GitHubUser) {
        try! persistanceManager.save(userData, title: "User Data")
        appUser = userData
    }
    
    private func loadTokenData() {
        guard let tokenData: AccessTokenResponse = try? persistanceManager.load(title: "Token Data") else {
            return
        }
        token = tokenData
    }
    
    func saveTokenData(_ tokenData: AccessTokenResponse) {
        try! persistanceManager.save(tokenData, title: "Token Data")
        token = tokenData
    }
    
    func userIsPersisted() -> Bool {
        // TODO: is token still valid? using different method for that might be better idea
        appUser != nil
    }
    
    func logUserOut() {
        persistanceManager.deletePersistedUserData()
        token = nil
        appUser = nil
    }
}
