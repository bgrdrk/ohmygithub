import Foundation

final class AppSessionManager {
    
    let persistanceManager: PersistanceCoordinator!
    
    private(set) var appUser: PublicGitHubUser?
    
    init(persistanceManager: PersistanceCoordinator) {
        self.persistanceManager = persistanceManager
        loadUserData()
    }
    
    // MARK: - Helpers
    
    private func loadUserData() {
        guard let userData: PublicGitHubUser = try? persistanceManager.load(title: "User Data") else {
            return
        }
        appUser = userData
    }
    
    func saveUserData(_ userData: PublicGitHubUser) {
        persistanceManager.save(userData, title: "User Data")
        appUser = userData
    }
    
    func userIsPersisted() -> Bool {
        // TODO: is token still valid? using different method for that might be better idea
        appUser != nil
    }
    
    func logUserOut() {
        persistanceManager.deletePersistedUserData()
        persistanceManager.deletePersistedTokenData()
        persistanceManager.deleteAllPersistedData()
        persistanceManager.cache.removeAllObjects()
        appUser = nil
    }
}
