import UIKit

class LoginViewController: UIViewController {

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
    
    //MARK: - Selectors
    @objc func handleLogin() {
        print("DEBUG: login touched")
    }
}

