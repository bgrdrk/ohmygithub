import UIKit

class MainCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    var viewControllersFactory: ViewControllersFactory
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.viewControllersFactory = ViewControllersFactory()
    }
    
    // MARK: - Lifecycle
    
    func start() {
        if viewControllersFactory.appSessionManager.userIsPersisted() {
            startAppSessionWithLoggedInUser()
        } else {
            startAuthenticationFlow()
        }
    }
    
    func restartFromUserVC() {
        dissmisCurrentVC()
        start()
    }
    
    func startAppSessionWithLoggedInUser() {
        let vc = viewControllersFactory.makeAppUserViewController(coordinator: self)
        vc.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Authentication Flow
    
    func startAuthenticationFlow() {
        guard navigationController.viewControllers.first is LoginViewController else {
            let vc = viewControllersFactory.makeLoginViewController(coordinator: self)
            navigationController.pushViewController(vc, animated: true)
            return
        }
    }
    
    // MARK: - Controlling the Navigation Stack
    
    func presentAccountsViewController(accounts: [GitHubAccount]) {
        let vc = viewControllersFactory.makeUsersViewController(coordinator: self, accounts: accounts)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentRepositoriesViewController(repositories: [Repository]) {
        let vc = viewControllersFactory.makeRepositoriesViewController(coordinator: self, repositories: repositories)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentRepositoryViewController(for repository: Repository) {
        let vc = viewControllersFactory.makeRepositoryViewController(coordinator: self, repository: repository)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentPublicGitHubUserViewController(for account: GitHubAccount) {
        let vc = viewControllersFactory.makePublicGitHubUserViewController(coordinator: self, account: account)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentEditUserViewController() {
        let vc = viewControllersFactory.makeEditUserViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToHomeViewController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func dissmisCurrentVC() {
        navigationController.popViewController(animated: true)
    }
}
