import Foundation

class ViewControllersFactory: DependencyContainer {
    
    // MARK: - ViewControllers factories
    
    func makeLoginViewController(coordinator: MainCoordinator) -> LoginViewController {
        let vc = LoginViewController(networkManager: networkManager, appSessionManager: appSessionManager)
        vc.coordinator = coordinator
        return vc
    }
    
    func makeGitHubUserViewController(coordinator: MainCoordinator) -> GitHubUserViewController {
        let vc = GitHubUserViewController(appSessionManager: appSessionManager)
        vc.coordinator = coordinator
        return vc
    }
}
