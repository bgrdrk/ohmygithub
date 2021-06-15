import UIKit
import WebKit

class AuthViewController: UIViewController {

    // MARK: - Properties
    
    private var webView = WKWebView()
    
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
        
        // gets tirggered if user presses cancel
        if let error = getQueryStringParameter(url: requestUrl, param: "error") {
            decisionHandler(.cancel)
            print("DEBUG: error -> \(error)")
            return
        }
        
        if let token = getQueryStringParameter(url: requestUrl, param: "code") {
            print("DEBUG: token -> \(token)")
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
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
