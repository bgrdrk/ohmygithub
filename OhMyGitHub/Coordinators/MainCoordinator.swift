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
    
    func restart() {
        popToHomeViewController()
        start()
    }
    
    func restartFromUserVC() {
        dissmisCurrentVC()
        start()
    }
    
    func startAppSessionWithLoggedInUser() {
        let vc = viewControllersFactory.makeGitHubUserViewController(coordinator: self)
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
    
    func presentFollowersViewController() {
        let vc = viewControllersFactory.makeFollowersViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentFollowingAccountsViewController() {
        let vc = viewControllersFactory.makeFollowingAccountsViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToHomeViewController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func dissmisCurrentVC() {
        navigationController.popViewController(animated: true)
    }
}
