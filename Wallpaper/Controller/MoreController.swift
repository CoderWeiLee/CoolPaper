//
//  MoreController.swift
//  Wallpaper
//
//  Created by 李伟 on 2020/12/25.
//

import UIKit
//import JXSegmentedView
import Alamofire
import KakaJSON
class MoreController: UIViewController{
    var scrollView: UIScrollView!
    var height: CGFloat = 0
    var beginY: CGFloat = 0
    var isBeginScroll: Bool = false //第一次按下
    var isBeginAnimationScroll: Bool = false //开始结束滑动scroll动画
    var isXiangHuaDong: Bool = false //
    struct Category: Encodable {
        let appkey: String
        let video: String
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .black
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.width, height: view.height * 2)
        scrollView.delegate = self
        loadResouses(0)
        view.addSubview(scrollView)
        addObserver(self, forKeyPath: "isBeginScroll", options: .new, context: nil)
            loadResouses(scrollView.height)
        
        

      
            
        //发起请求查询分页的数据
        let category = Category(appkey: "035d4cebaaf8bc9d9f5aa782368224ac", video: "1")
            AF.request(categoryListURL, method: .post, parameters: category).responseJSON {[self] (response) in
            if let responseModel = (response.data?.kj.model(CategoryResModel.self)){
//                self.dataArray = Array(responseModel.data!)
            }
        }
    }
    
    
    /// <#Description#>
    /// - Parameter startY: startY为当前屏幕显示的位置起始y坐标
    func loadResouses(_ startY: CGFloat) {
        let label = UILabel(frame: CGRect(x: view.width - 112, y: startY + scrollView.height - 386 , width: 90, height: 9))
        label.text = "1024"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .white
        scrollView.addSubview(label)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !isBeginScroll {
            let offsetY = scrollView.contentOffset.y
            if (!(abs(offsetY - beginY) > scrollView.height / 3.0)  && !isXiangHuaDong) {
                scrollView.setContentOffset(CGPoint(x: 0, y: beginY), animated: true)
                return
            }
            let scale = NSInteger(offsetY / scrollView.height)
            if offsetY >= beginY {
                if CGFloat(scale + 2) * scrollView.height >= scrollView.contentSize.height {
                    scrollView.contentSize = CGSize(width: view.width, height: scrollView.contentSize.height + scrollView.height)
                }
                
                //每次滑动scrollView自动扩容
                scrollView.setContentOffset(CGPoint(x: 0, y: CGFloat(scale + 1) * scrollView.height), animated: true)
                loadResouses(CGFloat(scale + 2) * scrollView.height)
            }
            if offsetY < beginY {
                if beginY >= view.height {
                    scrollView.setContentOffset(CGPoint(x: 0, y: CGFloat(scale) * scrollView.height), animated: true)
                }
            }
        }
    }
}

extension MoreController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isBeginScroll = true
        beginY = scrollView.contentOffset.y
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //停下自动滑动scrollView
        scrollView.setContentOffset(velocity, animated: true)
        //结束滑动scrollView
        isBeginScroll = false
        //开始滑动动画
        isBeginAnimationScroll = true
        if (abs(velocity.y) > 0.3) {
            isXiangHuaDong = true
        }else {
            isXiangHuaDong = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.setContentOffset(.zero, animated: true)
        //结束滑动scrollView
        isBeginScroll = false
        //开始滑动动画
        isBeginAnimationScroll = true
    }
    
    //结束滑动动画
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isBeginAnimationScroll {
            let currentY = scrollView.contentOffset.y
            let page = NSInteger(currentY / scrollView.height)
            //在这里可以处理滑动结束一些视频自动播放逻辑
        }
        isBeginAnimationScroll = false
    }
    
    
    
}
