//
//  KakaoZipCodeVC.swift
//  StockMate
//
//  Created by Admin on 11/5/25.
//


import UIKit
import WebKit

class KakaoZipCodeVC: UIViewController {

    // MARK: - Properties
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var onAddressSelected: ((String) -> Void)? // ✅ SwiftUI로 결과 전달용 콜백

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        setupLayout()
    }

    private func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: config)
        webView?.navigationDelegate = self

        guard let webView = webView,
              let url = URL(string: "https://yoo-hyuna.github.io/Kakao-Postcode/") else { return }

        webView.load(URLRequest(url: url))
    }

    private func setupLayout() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
        ])
    }
}

extension KakaoZipCodeVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let data = message.body as? [String: Any] else { return }
        let address = data["roadAddress"] as? String ?? ""
        onAddressSelected?(address)   // ✅ SwiftUI로 전달
        dismiss(animated: true)
    }
}

extension KakaoZipCodeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
