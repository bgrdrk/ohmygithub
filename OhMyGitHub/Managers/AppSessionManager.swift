import Foundation

final class AppSessionManager {
    
    let persistanceManager: PersistanceCoordinator!
    
    private(set) var token: AccessTokenResponse?
    private(set) var appUser: PublicGitHubUser?
    
    init(persistanceManager: PersistanceCoordinator) {
        self.persistanceManager = persistanceManager
        loadUserData()
        loadTokenData()
    }
    
    // MARK: - Helpers
    
    private func loadUserData() {
        guard let userData: PublicGitHubUser = try? persistanceManager.load(title: "User Data") else {
            return
        }
        appUser = userData
    }
    
    func saveUserData(_ userData: PublicGitHubUser) {
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
