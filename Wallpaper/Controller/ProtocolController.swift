//
//  ProtocolController.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//

import Foundation
import WebKit
class ProtocolController: UIViewController {
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "用户协议"
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
//        webView.load(URLRequest(url: URL(string: Bundle.main.path(forResource: "protocol", ofType: "html") ?? "")!))
        webView.loadFileURL(Bundle.main.url(forResource: "protocol", withExtension: "html")! , allowingReadAccessTo: Bundle.main.bundleURL)
    }
}
