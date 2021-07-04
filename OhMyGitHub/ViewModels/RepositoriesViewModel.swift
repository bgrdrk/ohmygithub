import Foundation

class RepositoriesViewModel {
    private let networkManager: NetworkManager!
    
    private(set) var repositories: [Repository]
    private(set) var sortedRepositories = Observable([Repository]())
    
    init(repositories: [Repository], networkManager: NetworkManager)
    {
        self.repositories = repositories
        self.networkManager = networkManager
    }
    
    func start() {
        sortRepositoriesByName()
    }
    
    
    // MARK: - Helpers
    
    func sortRepositoriesByName() {
        sortedRepositories.value = repositories.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    func sortRepositoriesByStarsCount() {
        sortedRepositories.value = repositories.sorted { $0.stargazersCount > $1.stargazersCount }
    }
}
