import Foundation

class DependencyContainer {
    lazy var persistanceManager = PersistanceManager()
    lazy var networkManager = NetworkManager(persistanceManager: persistanceManager)
    lazy var appSessionManager = AppSessionManager(persistanceManager: persistanceManager)
    // storageManager
    // coreDataManager
}
