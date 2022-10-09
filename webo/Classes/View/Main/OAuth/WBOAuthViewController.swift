//
//  WBOAuthViewController.swift
//  webo
//
//  Created by OMi on 2021/4/28.
//

import UIKit
import WebKit
import SVProgressHUD

// 通过 webview 加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {
    
    private lazy var webview = WKWebView()
    
    override func loadView() {
        view = webview
        view.backgroundColor = .white
        webview.scrollView.isScrollEnabled = false
        webview.navigationDelegate = self
        
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        guard let url = URL(string: urlString) else {
            return
        }
        //加载请求
        let request = URLRequest(url: url)
        webview.load(request)
    }
    

    @objc private func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        //Error Domain=WKErrorDomain Code=4 "A JavaScript exception occurred"
        //此错误有可能是元素 id 的名称是错误的
        let js = "document.getElementById('loginName').value = '527474808@qq.com';" + "document.getElementById('loginPassword').value = '920707love930521';"
        webview.evaluateJavaScript(js, completionHandler: nil)
    }
    
}

extension WBOAuthViewController: WKNavigationDelegate {
    //决定网页能否被允许跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //1、如果请求地址包含 http://baidu.com 不加载页面，否则加载页面
        //2、从 http://baidu.com 回调地址的查询字符串中查找 “code=”
        //3、如果有 “code=” ，授权成功，否则，授权失败
        let url = navigationAction.request.url
        
        if url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)//不允许网页跳转
        if url?.query?.hasPrefix("code=") == false {
            //取消授权
            close()
            return
        }
        
        let code = url?.query?.suffix(from: "code=".endIndex) ?? ""
        let strCode = String(code)
        //使用授权码换取 access_token
        WBNetworkManager.shared.loadAccessToken(code: strCode) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            } else {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
                self.close()
            }
        }
        
    }
    
    //处理网页开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    //处理网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    //处理网页加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
}
