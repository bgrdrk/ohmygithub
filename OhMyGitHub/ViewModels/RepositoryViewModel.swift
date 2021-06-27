import Foundation

class RepositoryViewModel {
    
    private let networkManager: NetworkManager!
    private let appSessionManager: AppSessionManager!
    private(set) var repository = Observable<Repository?>(nil)
    private(set) var contributors = Observable([GitHubAccount]())
    private(set) var presentedRepoIsStarredByAppUser = Observable(false)
    
    var onError: ((String?) -> Void)?
    
    init(repository: Repository, networkManager: NetworkManager, appSessionManager: AppSessionManager)
    {
        self.repository.value = repository
        self.networkManager = networkManager
        self.appSessionManager = appSessionManager
    }
    
    func start() {
        fetchContributors()
        checkIfAppUserStarredThisRepository()
    }
}

// MARK: - Netwark calls

extension RepositoryViewModel {
    
    private func fetchContributors() {
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
    
    private func checkIfAppUserStarredThisRepository() {
        guard let repository  = repository.value,
              let token = appSessionManager.token?.accessToken else {
            // TODO: Handle error swiftly
            print("DEBUG: Repository must not be nil here")
            return
        }
        
        let endpoint = EndpointCases.checkIfAppUserStarredThisRepository(login: repository.owner.login,
                                                                         repoName: repository.name,
                                                                         token: token)
        
        networkManager.checkIfAppUserStarredThisRepository(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let statusCode):
                self.presentedRepoIsStarredByAppUser.value = statusCode == 204
            }
        }
    }
    
    func toggleRepositoryStar() {
        
        guard let login  = repository.value?.owner.login,
              let repoName  = repository.value?.name,
              let token = appSessionManager.token?.accessToken else {
            // TODO: Handle error swiftly
            print("DEBUG: Repository must not be nil here")
            return
        }
        
        let endpoint: Endpoint
        if presentedRepoIsStarredByAppUser.value {
            endpoint = EndpointCases.unstarRepository(login: login, repoName: repoName, token: token)
        } else {
            endpoint = EndpointCases.starRepository(login: login, repoName: repoName, token: token)
        }
        presentedRepoIsStarredByAppUser.value.toggle()
        
        networkManager.toggleRepositoryStar(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let statusCode):
                print("\(statusCode) - status code of toggling repository star")
            }
        }
    }
}
