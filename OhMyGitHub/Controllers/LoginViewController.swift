import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    private var accessData: AccessTokenResponse?
    weak var coordinator: MainCoordinator?
    
    private let loginButton: UIButton = {
        let button = AppUI.actionButton(withText: "Login")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(loginButton)
        
        loginButton.center(inView: view)
        loginButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Selectors
    @objc func handleLogin() {
        coordinator?.startAuthViewController()
    }
}

