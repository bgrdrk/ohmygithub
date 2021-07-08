import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: LoginViewModel!
    weak var coordinator: MainCoordinator?
    
    private let loginButton: UIButton = {
        let button = AppUI.actionButton(withText: "Login")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    private let indicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    //MARK: - Selectors
    
    @objc func handleLogin() {
        handleGitHubAuth()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = AppUI.appColor(.lightGrey)
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(loginButton)
        view.addSubview(indicator)
        indicator.isHidden = true
        
        loginButton.center(inView: view)
        loginButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
        indicator.centerX(inView: view)
        indicator.anchor(bottom: loginButton.topAnchor, paddingBottom: AppUI.spacing)
    }
    
    private func bindViewModel() {
        viewModel.onLogin = { [weak self] in
            guard let self = self else { return }
            self.coordinator?.start()
        }
    }
    
    //MARK: - Authentication Session
    
    private func handleGitHubAuth() {
        let authorizeUrl = EndpointCases.authorization.urlWithComponents
        let callbackURLScheme = Secrets.callback
        
        let authenticationSession = ASWebAuthenticationSession(
            url: authorizeUrl,
            callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
            guard let self = self else { return }
            
            if let error = error {
                print("DEBUG: error -> \(error.localizedDescription)")
                return
            }
            
            guard
                let callbackURL = callbackURL,
                let code = self.viewModel.getQueryStringParameter(url: callbackURL, param: "code")
            else {
                self.coordinator?.presentAlert(title: "Login error", message: "Pleasy try again.")
                return
            }
            self.loginButton.isHidden = true
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.viewModel.getAccessTokenAndContinueAuth(using: code)
        }
        
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = true

        if !authenticationSession.start() {
            // TODO: Handle error swiftly
            print("DEBUG: error -> Failed to start ASWebAuthenticationSession")
        }
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
