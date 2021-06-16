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
        if startWithLoggedInUser {
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
        navigationController.present(vc, animated: false, completion: nil)
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
