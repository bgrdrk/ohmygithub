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
    
    private let showUserButton: UIButton = {
        let button = AppUI.actionButton(withText: "Show User")
        button.addTarget(self, action: #selector(handleShowUserButtonTap), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(loginButton)
        view.addSubview(showUserButton)
        
        loginButton.center(inView: view)
        loginButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
        showUserButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        showUserButton.isEnabled = false
        showUserButton.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Selectors
    @objc func handleLogin() {
        // coordinator start AuthViewController()
        // AuthViewController() needs a way to communicate to NC and let it know about the outcome of authentication
        // AuthViewController() communicates with coordinator:
        //      1. on success dissmiss and go back to rootview start() the flow again
        //      2. on error show alert and then dissmiss?
        coordinator?.startAuthViewController()
    }
    
    @objc func handleShowUserButtonTap() {
        print("DEBUG: accessData -> \(accessData)")
        NetworkManager.shared.getGitHubUser(token: accessData!.accessToken) { [weak self] result in
            switch result {
            case .failure(let error):
                print("DEBUG: error -> \(error.message)")
            case .success(let data):
                print("DEBUG: decoded Data -> \(data)")
            }
        }
    }
}

extension LoginViewController: AuthViewControllerDelegate {
    func authViewController(didReceiveAccess data: AccessTokenResponse) {
        accessData = data
        showUserButton.isEnabled = true
        showUserButton.alpha = 1
    }
}

