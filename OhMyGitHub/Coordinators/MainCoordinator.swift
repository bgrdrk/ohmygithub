import UIKit

class MainCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    var startWithLoggedInUser = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if startWithLoggedInUser {
            startAppSessionWithLoggedInUser()
        } else {
            startAuthenticationFlow()
        }
    }
    
    func restart() {
        navigationController.popToRootViewController(animated: false)
        start()
    }
    
    func startAppSessionWithLoggedInUser() {
        let vc = GitHubUserViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = false
        navigationController.present(vc, animated: false)
    }
    
    // MARK: - Authentication Flow
    
    func startAuthenticationFlow() {
        let vc = LoginViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startAuthViewController() {
        let vc = AuthViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
