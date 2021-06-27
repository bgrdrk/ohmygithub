import Foundation

class ViewControllersFactory: DependencyContainer {
    
    // MARK: - ViewControllers factories
    
    func makeLoginViewController(coordinator: MainCoordinator) -> LoginViewController {
        let viewModel = LoginViewModel(appSessionManager: appSessionManager, networkManager: networkManager)
        let vc = LoginViewController(viewModel: viewModel)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeAppUserViewController(coordinator: MainCoordinator) -> AppUserViewController {
        let viewModel = AppUserViewModel(appSessionManager: appSessionManager, networkManager: networkManager)
        let vc = AppUserViewController(viewModel: viewModel)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeAccountsViewController(coordinator: MainCoordinator, accounts: [GitHubAccount]) -> UsersViewController {
        let vc = UsersViewController(accounts: accounts)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeRepositoriesViewController(coordinator: MainCoordinator, repositories: [Repository]) -> RepositoriesViewController {
        let vc = RepositoriesViewController(repositories: repositories)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeRepositoryViewController(coordinator: MainCoordinator, repository: Repository) -> RepositoryViewController {
        let viewModel = RepositoryViewModel(repository: repository, networkManager: networkManager, appSessionManager: appSessionManager)
        let vc = RepositoryViewController(viewModel: viewModel)
        vc.coordinator = coordinator
        return vc
    }
    
    func makePublicGitHubUserViewController(coordinator: MainCoordinator, account: GitHubAccount) -> PublicUserViewController {
        let viewModel = PublicUserViewModel(account: account, networkManager: networkManager, appSessionManager: appSessionManager)
        let vc = PublicUserViewController(viewModel: viewModel)
        vc.coordinator = coordinator
        return vc
    }
}
