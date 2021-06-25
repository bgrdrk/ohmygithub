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
    
    func makePublicGitHubUserViewController(coordinator: MainCoordinator, account: GitHubAccount) -> PublicUserViewController {
        let viewModel = PublicUserViewModel(account: account, networkManager: networkManager)
        let vc = PublicUserViewController(viewModel: viewModel)
        vc.coordinator = coordinator
        return vc
    }
}
