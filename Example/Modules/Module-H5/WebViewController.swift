//
//  WebViewController.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/8.
//

import UIKit
import WebKit
import X_Router
import Base

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, RoutableWebController {
    
    // MARK: - Property (retain)
    
    private(set) var webView: WKWebView!
    
    private let progressBar = UIProgressView(progressViewStyle: .bar)
    
    private var observations = [NSKeyValueObservation]()
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.webView = WKWebView.init(frame: .zero, configuration: .init())
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.bounds
        progressBar.frame = CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height + 44, width: view.bounds.width, height: 2)
        self.view.addSubview(webView)
        self.view.addSubview(progressBar)
        
        self.observations.append(self.webView.observe(\.title) { [weak self] webView, _ in
            self?.navigationItem.title = webView.title
        })
        self.observations.append(self.webView.observe(\.estimatedProgress, changeHandler: { [weak self] webView, _ in
            let progress = Float(webView.estimatedProgress)
            self?.progressBar.progress = progress
            self?.progressBar.isHidden = progress == 1
        }))
    }
    
    private func getHTMLData(_ urlStr: String) {
        guard let HTTPService = Router.getServiceType(with: "HTTPService") as? NetworkService.Type else { return }
        HTTPService.request(.init(url: .init(string: urlStr)!)) { result in
            switch result {
            case .success(let data):
                print("data ->", String(data: data, encoding: .utf8) ?? "")
            case .failure(let error):
                print("error ->", error)
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
        
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        
    }
    
    // MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Confirm", style: .default, handler: { _ in
            completionHandler()
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func update(parameters: Router.Parameters) {
        guard let url = parameters["url"] as? URL else { return }
        self.webView.load(.init(url: url))
        self.getHTMLData(url.absoluteString)
    }
    
    func merge(parameters: Router.Parameters) {
        
    }
}

