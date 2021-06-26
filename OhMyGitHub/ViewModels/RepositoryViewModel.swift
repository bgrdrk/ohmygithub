import Foundation

class RepositoryViewModel {
    private let networkManager: NetworkManager!
//    private let repository: Repository!
    
    private(set) var contributors = Observable([GitHubAccount]())
    private(set) var repository02 = Observable<Repository?>(nil)
    
    var onError: ((String?) -> Void)?
    var didInit: (() -> Void)?
    
    init(repository: Repository, networkManager: NetworkManager)
    {
        self.repository02.value = repository
        self.networkManager = networkManager
    }
    
    func start() {
        fetchContributors()
        didInit?()
    }
}

// MARK: - Netwark calls

private extension RepositoryViewModel {
    
    func fetchContributors() {
        let endpoint = EndpointCases.getRepositoryContributors(userName: repository02.value!.owner.login, repoName: repository02.value!.name)
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
