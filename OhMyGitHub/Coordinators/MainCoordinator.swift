import UIKit

class MainCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    var viewControllersFactory: ViewControllersFactory
    var startWithLoggedInUser = false
    
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
        popToHomeViewControllerWithoutAnimation()
        start()
    }
    
    func startAppSessionWithLoggedInUser() {
        let vc = viewControllersFactory.makeGitHubUserViewController(coordinator: self)
        vc.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: false)
    }
    
    // MARK: - Authentication Flow
    
    func startAuthenticationFlow() {
        let vc = viewControllersFactory.makeLoginViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startAuthViewController() {
        let vc = viewControllersFactory.makeAuthViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
    
    func popToHomeViewControllerWithoutAnimation() {
        navigationController.popToRootViewController(animated: false)
    }
}
