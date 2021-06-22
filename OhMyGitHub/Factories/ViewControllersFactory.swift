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
    
    func makeUsersViewController(coordinator: MainCoordinator) -> UsersViewController {
        let vc = UsersViewController(networkManager: networkManager, appSessionManager: appSessionManager)
        vc.coordinator = coordinator
        return vc
    }
}
