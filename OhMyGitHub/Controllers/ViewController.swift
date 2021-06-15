import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    private var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.backgroundColor = .blue
        webView.anchor(top: view.topAnchor,
                       left: view.leftAnchor,
                       bottom: view.bottomAnchor,
                       right: view.rightAnchor,
                       paddingTop: 100, paddingLeft: 20, paddingBottom: 50, paddingRight: 20)
        
        let url = getAuthenticateURL_asGithubApp()
        openURL(url)
    }
    
    func getAuthenticateURL_asGithubApp() -> URL {
        var urlComponent = URLComponents(string: "https://github.com/login/oauth/authorize")!
        var queryItems =  urlComponent.queryItems ?? []
        queryItems.append(URLQueryItem(name: "client_id", value: Secrets.clientId))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: Secrets.callback))
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
    
    private func openURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("DEBUG: navigationaction -> \(navigationAction.request.url)")
        decisionHandler(.allow)
    }
}

