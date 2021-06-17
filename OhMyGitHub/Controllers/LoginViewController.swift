import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var accessData: AccessTokenResponse?
    weak var coordinator: MainCoordinator?
    var networkManager: NetworkManager!
    var appSessionManager: AppSessionManager!
    
    private let loginButton: UIButton = {
        let button = AppUI.actionButton(withText: "Login")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    init(networkManager: NetworkManager, appSessionManager: AppSessionManager) {
        self.networkManager = networkManager
        self.appSessionManager = appSessionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        handleGitHubAuth()
    }
    
    private func handleGitHubAuth() {
        let signInURL = makeAuthenticationURL()
        let callbackURLScheme = Secrets.callback
        
        let authenticationSession = ASWebAuthenticationSession(
            url: signInURL,
            callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
            guard let self = self else { return }
            
            if let error = error {
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.localizedDescription)")
                return
            }
            
            guard
                let callbackURL = callbackURL,
                let code = self.getQueryStringParameter(url: callbackURL, param: "code")
            else {
                // TODO: Handle error swiftly
                print("DEBUG: error, callbackURL is nil or has no code? -> \(#function)")
                return
            }
            
            self.getAccessTokenAndContinueAuth(using: code)
        }
        
        authenticationSession.presentationContextProvider = self
//        authenticationSession.prefersEphemeralWebBrowserSession = true

        if !authenticationSession.start() {
            // TODO: Handle error swiftly
            print("DEBUG: error -> Failed to start ASWebAuthenticationSession")
        }
    }
    
    private func getAccessTokenAndContinueAuth(using code: String) {
        let url = self.makeAccessTokenURL(with: code)
        self.networkManager.getAccessToken(url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.message)")
            case .success(let accessTokenData):
                self.appSessionManager.saveTokenData(accessTokenData)
                self.fetchLoggedInUserData(with: accessTokenData)
            }
        }
    }
    
    private func makeAuthenticationURL() -> URL {
        var urlComponent = URLComponents(string: "https://github.com/login/oauth/authorize")!
        var queryItems =  urlComponent.queryItems ?? []
        queryItems.append(URLQueryItem(name: "client_id", value: Secrets.clientId))
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
    
    private func makeAccessTokenURL(with code: String) -> URL {
        var urlComponent = URLComponents(string: "https://github.com/login/oauth/access_token")!
        var queryItems =  urlComponent.queryItems ?? []
        queryItems.append(URLQueryItem(name: "client_id", value: Secrets.clientId))
        queryItems.append(URLQueryItem(name: "client_secret", value: Secrets.clientSecret))
        queryItems.append(URLQueryItem(name: "code", value: code))
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
    
    private func fetchLoggedInUserData(with accessData: AccessTokenResponse) {
        networkManager.getGitHubUser(token: accessData.accessToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.message)")
            case .success(let gitHubUserData):
                self.appSessionManager.saveUserData(gitHubUserData)
//                DispatchQueue.main.async {
//                    self.coordinator?.restart()
//                }
            }
        }
    }
    
    private func getQueryStringParameter(url: URL, param: String) -> String? {
        guard let url = URLComponents(string: url.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
