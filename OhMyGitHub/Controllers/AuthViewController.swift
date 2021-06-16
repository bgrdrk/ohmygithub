import UIKit
import WebKit

class AuthViewController: UIViewController {

    // MARK: - Properties
    
    private var webView = WKWebView()
    weak var coordinator: MainCoordinator?
    var networkManager: NetworkManager!
    var appSessionManager: AppSessionManager!
    
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
        configureUI()
        configureWebViewAndOpenURL()
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI
    
    private func configureUI(){
        
    }
}

// MARK: - WebKit
extension AuthViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        guard let requestUrl = navigationAction.request.url?.absoluteString else {
            decisionHandler(.cancel)
            return
        }
        
        // gets triggered if user presses cancel
        if let error = getQueryStringParameter(url: requestUrl, param: "error"),
           let errorDescription = getQueryStringParameter(url: requestUrl, param: "error_description")
           {
            decisionHandler(.cancel)
            // TODO: Show the alert with information and handle navigation
            print("DEBUG: error -> \(error)")
            print("DEBUG: error description -> \(errorDescription)")
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        
        if let token = getQueryStringParameter(url: requestUrl, param: "code") {
            let url = makeAccessTokenURL(with: token)
            fetchAccessTokenData(through: url)
        }
        decisionHandler(.allow)
    }
    
    private func fetchAccessTokenData(through url: URL) {
        networkManager.getAccessToken(url) { [weak self] result in
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
    
    private func fetchLoggedInUserData(with accessData: AccessTokenResponse) {
        networkManager.getGitHubUser(token: accessData.accessToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.message)")
            case .success(let gitHubUserData):
                self.appSessionManager.saveUserData(gitHubUserData)
                DispatchQueue.main.async {
                    self.coordinator?.restart()
                }
            }
        }
    }
    
    private func configureWebViewAndOpenURL() {
        webView.navigationDelegate = self
        let url = makeAuthenticationURL()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func makeAuthenticationURL() -> URL {
        var urlComponent = URLComponents(string: "https://github.com/login/oauth/authorize")!
        var queryItems =  urlComponent.queryItems ?? []
        queryItems.append(URLQueryItem(name: "client_id", value: Secrets.clientId))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: Secrets.callback))
//        TODO: This should contain a random string to protect against forgery attacks and could contain any other arbitrary data.
//        queryItems.append(URLQueryItem(name: "state", value: "Random String"))
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
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
