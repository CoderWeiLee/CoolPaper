//
//  MyTabBarController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
class MyTabBarController: UITabBarController {
//    override func loadView() {
//        if let bundleID = Bundle.main.bundleIdentifier {
//            Bundle.main.changeIdentifier(bundleID)
//        }
//        super.loadView()
//    }
    
    var mytabBar: CCTabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        mytabBar = CCTabBar()
        addChildViewControllers()
        self.tabBar.tintColor = UIColor(named: "indicatorColor")
    }
    
    private func addChildViewControllers() {
        setChildViewController(HomeController(), title: "首页", imageName: "tab-recommend")
        setChildViewController(MoreController(), title: "更多", imageName: "tab-explore")
        setChildViewController(DiscoverController(), title: "社区", imageName: "post_normal")
        setChildViewController(DIYController(), title: "工具", imageName: "tab-social")
        setChildViewController(MyController(), title: "我的", imageName: "tab-mine")
    }
    
    private func setChildViewController(_ childController: UIViewController, title: String, imageName: String) {
        if imageName == "post_normal" {
            childController.tabBarItem.image = UIImage(named: imageName)
            childController.tabBarItem.selectedImage = UIImage(named: imageName)
        }else {
            childController.tabBarItem.image = UIImage(named: imageName)
            childController.tabBarItem.selectedImage = UIImage(named: imageName + "-active")
        }
        childController.title = title
        let navVc = MyNavigationController(rootViewController: childController)
        addChild(navVc)
    }
    
    
}
