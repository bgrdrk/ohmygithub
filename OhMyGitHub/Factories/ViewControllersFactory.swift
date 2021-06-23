import Foundation

class ViewControllersFactory: DependencyContainer {
    
    // MARK: - ViewControllers factories
    
    func makeLoginViewController(coordinator: MainCoordinator) -> LoginViewController {
        let vc = LoginViewController(networkManager: networkManager, appSessionManager: appSessionManager)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeGitHubUserViewController(coordinator: MainCoordinator) -> GitHubUserViewController {
        let vc = GitHubUserViewController(networkManager: networkManager, appSessionManager: appSessionManager)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeFollowersViewController(coordinator: MainCoordinator) -> UsersViewController {
        let vc = UsersViewController(users: appSessionManager.usersFollowers)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeFollowingAccountsViewController(coordinator: MainCoordinator) -> UsersViewController {
        let vc = UsersViewController(users: appSessionManager.usersFollowedAccounts)
        vc.coordinator = coordinator
        return vc
    }
    
    func makePublicGitHubUserViewController(coordinator: MainCoordinator, account: GitHubAccount) -> PublicGitHubUserViewController {
        let viewModel = PublicGitHubUserViewModel(account: account, networkManager: networkManager)
        let vc = PublicGitHubUserViewController(viewModel: viewModel)
        return vc
    }
}
