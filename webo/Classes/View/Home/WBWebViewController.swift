//
//  WBWebViewController.swift
//  webo
//
//  Created by OMi on 2021/5/17.
//

import UIKit
import WebKit

class WBWebViewController: WBBaseViewController {

    private lazy var webView = WKWebView(frame: UIScreen.main.bounds)

    var urlString: String? {
        didSet {
            guard let urlString = urlString,
                  let url = URL(string: urlString) else {
                return
            }
            
            webView.load(URLRequest(url: url))
        }
    }
    
}

extension WBWebViewController {
    override func setupTableView() {
        navigationItem.title = "网页"
        
        //设置webview
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = .white
        
        webView.scrollView.contentInset.top = NAV_BAR_HEIGHT
    }
}
