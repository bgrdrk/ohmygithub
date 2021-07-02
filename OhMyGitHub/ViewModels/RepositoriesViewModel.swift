import Foundation

class RepositoriesViewModel {
    private let networkManager: NetworkManager!
    
    private(set) var repositories = Observable([Repository]())
    
    init(repositories: [Repository], networkManager: NetworkManager)
    {
        self.repositories.value = repositories
        self.networkManager = networkManager
    }
    
    func start() {
        
    }
    
    
    // MARK: - Helpers
    
}
