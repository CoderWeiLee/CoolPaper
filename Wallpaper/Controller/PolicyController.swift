//
//  PolicyController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//

import Foundation
import WebKit
class PolicyController: UIViewController {
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户协议"
        view.backgroundColor = .white
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.loadFileURL(Bundle.main.url(forResource: "policy", withExtension: "html")! , allowingReadAccessTo: Bundle.main.bundleURL)
    }
}
