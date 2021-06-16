import UIKit
import WebKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(didReceiveAccess data: AccessTokenResponse)
}

class AuthViewController: UIViewController {

    // MARK: - Properties
    
    private var webView = WKWebView()
    weak var delegate: AuthViewControllerDelegate?
    weak var coordinator: MainCoordinator?
    
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
    
   
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print("DEBUG: navigationResponse -> \(navigationResponse.response)")
//        decisionHandler(.allow)
//    }

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
            print("DEBUG: error -> \(error)")
            print("DEBUG: error description -> \(errorDescription)")
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        
        if let token = getQueryStringParameter(url: requestUrl, param: "code") {
            print("DEBUG: token -> \(token)")
            let url = getAccessTokenURL(with: token)
            
            NetworkManager.shared.getAccessToken(url) { [weak self] result in
                switch result {
                case .failure(let error):
                    print("DEBUG: error -> \(error.message)")
                case .success(let data):
                    // perduodam data sessionManager'iui?
                    DispatchQueue.main.async {
                        self?.coordinator?.startWithLoggedInUser = true
                        self?.coordinator?.restart()
                    }
                }
            }
        }
        decisionHandler(.allow)
    }
    
    private func configureWebViewAndOpenURL() {
        webView.navigationDelegate = self
        let url = getAuthenticateURL()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func getAuthenticateURL() -> URL {
        var urlComponent = URLComponents(string: "https://github.com/login/oauth/authorize")!
        var queryItems =  urlComponent.queryItems ?? []
        queryItems.append(URLQueryItem(name: "client_id", value: Secrets.clientId))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: Secrets.callback))
        // This should contain a random string to protect against forgery attacks and could contain any other arbitrary data.
        queryItems.append(URLQueryItem(name: "state", value: "Random String"))
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
    
    private func getAccessTokenURL(with code: String) -> URL {
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
