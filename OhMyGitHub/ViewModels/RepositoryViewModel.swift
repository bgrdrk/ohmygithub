import Foundation

class RepositoryViewModel {
    
    private let networkManager: NetworkManager!
    private(set) var repository = Observable<Repository?>(nil)
    private(set) var contributors = Observable([GitHubAccount]())
    
    var onError: ((String?) -> Void)?
    
    init(repository: Repository, networkManager: NetworkManager)
    {
        self.repository.value = repository
        self.networkManager = networkManager
    }
    
    func start() {
        fetchContributors()
    }
}

// MARK: - Netwark calls

private extension RepositoryViewModel {
    
    func fetchContributors() {
        guard let repository  = repository.value else {
            // TODO: Handle error swiftly
            print("DEBUG: Repository must not be nil here")
            return
        }
        let endpoint = EndpointCases.getRepositoryContributors(userName: repository.owner.login, repoName: repository.name)
        networkManager.getRepositoryContributors(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let contributors):
                self.contributors.value = contributors
            }
        }
    }
}
