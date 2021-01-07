//
//  HXPHPickerInteractiveTransition.swift
//  HXPHPickerExample
//
//  Created by Slience on 2020/12/26.
//  Copyright © 2020 Silence. All rights reserved.
//

import UIKit

enum HXPHPickerInteractiveTransitionType: Int {
    case pop
    case dismiss
}
class HXPHPickerInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    var type: HXPHPickerInteractiveTransitionType
    weak var previewViewController: HXPHPreviewViewController?
    weak var pickerController: HXPHPickerController?
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureRecognizerAction(panGR:)))
        return panGestureRecognizer
    }()
    lazy var backgroundView: UIView = {
        let backgroundView = UIView.init()
        return backgroundView
    }()
    var previewView: HXPHPreviewViewCell?
    var toView: UIView?
    var beforePreviewFrame: CGRect = .zero
    var previewCenter: CGPoint = .zero
    var beganPoint: CGPoint = .zero
    var canInteration: Bool = false
    var beganInterPercent: Bool = false
    var previewBackgroundColor: UIColor?
    var pickerControllerBackgroundColor: UIColor?
    weak var transitionContext: UIViewControllerContextTransitioning?
    var slidingGap: CGPoint = .zero
    
    init(panGestureRecognizerFor previewViewController: HXPHPreviewViewController, type: HXPHPickerInteractiveTransitionType) {
        self.type = type
        super.init()
        self.previewViewController = previewViewController
        panGestureRecognizer.delegate = self
        previewViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    init(panGestureRecognizerFor pickerController: HXPHPickerController, type: HXPHPickerInteractiveTransitionType) {
        self.type = type
        super.init()
        self.pickerController = pickerController
        panGestureRecognizer.delegate = self
        pickerController.view.addGestureRecognizer(panGestureRecognizer)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(previewViewController?.collectionView.isDragging ?? false)
    }
    
    @objc func panGestureRecognizerAction(panGR: UIPanGestureRecognizer) {
        var isTracking = false
        if type == .pop {
            if let cell = previewViewController?.getCell(for: previewViewController?.currentPreviewIndex ?? 0) {
                if  ((cell.scrollView.isZooming || cell.scrollView.isZoomBouncing || cell.scrollView.contentOffset.y > 0 || !cell.allowInteration)) && !canInteration {
                    return
                }else {
                    isTracking = cell.scrollView.isTracking
                }
            }
        }else {
            let previewVC = pickerController?.previewViewController()
            if let cell = previewVC?.getCell(for: previewVC?.currentPreviewIndex ?? 0) {
                if  ((cell.scrollView.isZooming || cell.scrollView.isZoomBouncing || cell.scrollView.contentOffset.y > 0 || !cell.allowInteration)) && !canInteration {
                    return
                }else {
                    isTracking = cell.scrollView.isTracking
                }
            }
        }
        switch panGR.state {
        case .began:
            beginInteration(panGR: panGR)
            if canInteration {
                
            }
            break
        case .changed:
            if !canInteration || !beganInterPercent {
                if isTracking {
                    beginInteration(panGR: panGR)
                    if canInteration {
                        slidingGap = panGR.translation(in: panGR.view)
                    }
                }
                return
            }
            if let previewViewController = previewViewController, let previewView = previewView {
                let translation = panGR.translation(in: panGR.view)
                var scale = (translation.y - slidingGap.y) / (previewViewController.view.height)
                if (scale > 1) {
                    scale = 1
                }else if scale < 0 {
                    scale = 0
                }
                var previewViewScale = 1 - scale
                if previewViewScale < 0.4 {
                    previewViewScale = 0.4
                }
                previewView.center = CGPoint(x: previewCenter.x + (translation.x - slidingGap.x), y: previewCenter.y + (translation.y - slidingGap.y))
                previewView.transform = CGAffineTransform.init(scaleX: previewViewScale, y: previewViewScale)
                
                var alpha = 1 - scale * 2
                if alpha < 0 {
                    alpha = 0
                }
                backgroundView.alpha = alpha
                let toVC = transitionContext?.viewController(forKey: .to) as? HXPHPickerViewController
                if !previewViewController.statusBarShouldBeHidden {
                    previewViewController.bottomView.alpha = alpha
                    if type == .pop {
                        if HXPHAssetManager.authorizationStatusIsLimited() && toVC?.config.bottomView.showPrompt ?? false {
                            toVC?.bottomView.alpha = 1 - alpha
                        }
                    }else {
                        previewViewController.navigationController?.navigationBar.alpha = alpha
                    }
                }else {
                    if type == .pop {
                        toVC?.navigationController?.navigationBar.alpha = 1 - alpha
                        toVC?.bottomView.alpha = 1 - alpha
                    }
                }
                
                update(1 - alpha)
            }
            break
        case .ended, .cancelled, .failed:
            if !canInteration {
                return
            }
            if let previewViewController = previewViewController {
                let translation = panGR.translation(in: panGR.view)
                let scale = (translation.y - slidingGap.y) / (previewViewController.view.height)
                if scale < 0.15 {
                    cancel()
                    interPercentDidCancel()
                }else {
                    finish()
                    interPercentDidFinish()
                }
            }else {
                finish()
                backgroundView.removeFromSuperview()
                previewView?.removeFromSuperview()
                previewView = nil
                previewViewController = nil
                toView = nil
                transitionContext?.completeTransition(true)
                transitionContext = nil
            }
            slidingGap = .zero
            break
        default:
            break
        }
    }
    func beginInteration(panGR: UIPanGestureRecognizer) {
        if type == .pop, let previewViewController = previewViewController {
            let velocity = panGR.velocity(in: previewViewController.view)
            let isVerticalGesture = (abs(velocity.y) > abs(velocity.x) && velocity.y > 0)
            if !isVerticalGesture {
                return
            }
            beganPoint = panGR.location(in: panGR.view)
            canInteration = true
            previewViewController.navigationController?.popViewController(animated: true)
        }else if type == .dismiss, let pickerController = pickerController {
            let velocity = panGR.velocity(in: pickerController.view)
            let isVerticalGesture = (abs(velocity.y) > abs(velocity.x) && velocity.y > 0)
            if !isVerticalGesture {
                return
            }
            beganPoint = panGR.location(in: panGR.view)
            canInteration = true
            pickerController.dismiss(animated: true, completion: nil)
        }
    }
    func interPercentDidCancel() {
        if let previewViewController = previewViewController, let previewView = previewView {
            panGestureRecognizer.isEnabled = false
            previewViewController.navigationController?.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25) {
                previewView.transform = .identity
                previewView.center = self.previewCenter
                self.backgroundView.alpha = 1
                let toVC = self.transitionContext?.viewController(forKey: .to) as? HXPHPickerViewController
                if !previewViewController.statusBarShouldBeHidden {
                    previewViewController.bottomView.alpha = 1
                    if self.type == .pop {
                        if HXPHAssetManager.authorizationStatusIsLimited() && toVC?.config.bottomView.showPrompt ?? false {
                            toVC?.bottomView.alpha = 0
                        }
                    }else {
                        previewViewController.navigationController?.navigationBar.alpha = 1
                    }
                }else {
                    if self.type == .pop {
                        toVC?.navigationController?.navigationBar.alpha = 0
                        toVC?.bottomView.alpha = 0
                    }
                }
            } completion: { (isFinished) in
                self.toView?.isHidden = false
                let toVC = self.transitionContext?.viewController(forKey: .to) as? HXPHPickerViewController
                if previewViewController.statusBarShouldBeHidden {
                    if self.type == .pop {
                        previewViewController.navigationController?.setNavigationBarHidden(true, animated: false)
                        toVC?.navigationController?.setNavigationBarHidden(true, animated: false)
                        toVC?.bottomView.alpha = 1
                        toVC?.navigationController?.navigationBar.alpha = 1
                    }
                }else {
                    if self.type == .pop {
                        if HXPHAssetManager.authorizationStatusIsLimited() && toVC?.config.bottomView.showPrompt ?? false {
                            toVC?.bottomView.alpha = 1
                        }
                    }
                }
                self.resetScrollView(for: true)
                previewView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                previewView.frame = self.beforePreviewFrame
                previewViewController.collectionView.addSubview(previewView)
                previewView.scrollContentView?.showOtherSubview()
                self.backgroundView.removeFromSuperview()
                self.previewView = nil
                self.toView = nil
                self.panGestureRecognizer.isEnabled = true
                self.canInteration = false
                self.beganInterPercent = false
                previewViewController.navigationController?.view.isUserInteractionEnabled = true
                self.transitionContext?.completeTransition(false)
                self.transitionContext = nil
            }
        }
    }
    func interPercentDidFinish() {
        if let previewViewController = previewViewController, let previewView = previewView {
            panGestureRecognizer.isEnabled = false
            var toRect = toView?.convert(toView?.bounds ?? .zero, to: transitionContext?.containerView) ?? .zero
            if type == .dismiss, let pickerController = pickerController {
                if toRect.isEmpty {
                    toRect = pickerController.pickerControllerDelegate?.pickerController?(pickerController, dismissPreviewFrameForIndexAt: previewViewController.currentPreviewIndex) ?? .zero
                }
                if let toView = toView, toView.layer.cornerRadius > 0 {
                    previewView.layer.masksToBounds = true
                }
            }
            previewView.scrollContentView?.isBacking = true
            UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.layoutSubviews, .curveEaseOut]) {
                if let toView = self.toView, toView.layer.cornerRadius > 0 {
                    previewView.layer.cornerRadius = toView.layer.cornerRadius
                }
                if !toRect.isEmpty {
                    previewView.transform = .identity
                    previewView.frame = toRect
                    previewView.scrollView.contentOffset = .zero
                    previewView.scrollContentView?.frame = CGRect(x: 0, y: 0, width: toRect.width, height: toRect.height)
                }else {
                    previewView.alpha = 0
                    previewView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }
                self.backgroundView.alpha = 0
                let toVC = self.transitionContext?.viewController(forKey: .to) as? HXPHPickerViewController
                if !previewViewController.statusBarShouldBeHidden {
                    previewViewController.bottomView.alpha = 0
                    if self.type == .pop {
                        if HXPHAssetManager.authorizationStatusIsLimited() && toVC?.config.bottomView.showPrompt ?? false {
                            toVC?.bottomView.alpha = 1
                        }
                    }else {
                        previewViewController.navigationController?.navigationBar.alpha = 0
                    }
                }else {
                    if self.type == .pop {
                        toVC?.bottomView.alpha = 1
                        toVC?.navigationController?.navigationBar.alpha = 1
                    }
                }
            } completion: { (isFinished) in
                self.toView?.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    previewView.alpha = 0
                } completion: { (isFinished) in
                    self.backgroundView.removeFromSuperview()
                    previewView.removeFromSuperview()
                    if self.type == .dismiss, let pickerController = self.pickerController {
                        pickerController.pickerControllerDelegate?.pickerController?(pickerController, previewDismissComplete: previewViewController.currentPreviewIndex)
                    }else if self.type == .pop, let toVC = self.transitionContext?.viewController(forKey: .to) as? HXPHPickerViewController {
                        toVC.collectionView.layer.removeAllAnimations()
                    }
                    self.previewView = nil
                    self.previewViewController = nil
                    self.toView = nil
                    self.panGestureRecognizer.isEnabled = true
                    self.transitionContext?.completeTransition(true)
                    self.transitionContext = nil
                }
            }
        }
    }
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        if type == .pop {
            popTransition(transitionContext)
        }else {
            dismissTransition(transitionContext)
        }
    }
    func popTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let previewViewController = transitionContext.viewController(forKey: .from) as! HXPHPreviewViewController
        previewBackgroundColor = previewViewController.view.backgroundColor
        previewViewController.view.backgroundColor = .clear
        let pickerViewController = transitionContext.viewController(forKey: .to) as! HXPHPickerViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(pickerViewController.view)
        containerView.addSubview(previewViewController.view)
        backgroundView.frame = pickerViewController.view.bounds
        backgroundView.backgroundColor = previewBackgroundColor
        pickerViewController.view.insertSubview(backgroundView, at: 1)
        if !previewViewController.previewAssets.isEmpty {
            let photoAsset = previewViewController.previewAssets[previewViewController.currentPreviewIndex]
            if let pickerCell = pickerViewController.getCell(for: photoAsset) {
                pickerViewController.scrollCellToVisibleArea(pickerCell)
                toView = pickerCell
            }else {
                pickerViewController.scrollToCenter(for: photoAsset)
                pickerViewController.reloadCell(for: photoAsset)
                let pickerCell = pickerViewController.getCell(for: photoAsset)
                toView = pickerCell
            }
        }
        
        if let previewCell = previewViewController.getCell(for: previewViewController.currentPreviewIndex) {
            beforePreviewFrame = previewCell.frame
            previewView = previewCell
        }
        previewView?.scrollView.clipsToBounds = false
        
        if let previewView = previewView {
            let anchorPoint = CGPoint(x: beganPoint.x / previewView.width, y: beganPoint.y / previewView.height)
            previewView.layer.anchorPoint = anchorPoint
            previewView.frame = pickerViewController.view.bounds
            previewCenter = previewView.center
            pickerViewController.view.insertSubview(previewView, aboveSubview: backgroundView)
        }
        if previewViewController.statusBarShouldBeHidden {
            pickerViewController.bottomView.alpha = 0
            pickerViewController.navigationController?.navigationBar.alpha = 0
            previewViewController.navigationController?.setNavigationBarHidden(false, animated: false)
        }else {
            if HXPHAssetManager.authorizationStatusIsLimited() && previewViewController.config.bottomView.showPrompt {
                pickerViewController.bottomView.alpha = 0
            }
        }
        resetScrollView(for: false)
        toView?.isHidden = true
        beganInterPercent = true
    }
    func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let pickerController = transitionContext.viewController(forKey: .from) as! HXPHPickerController
        pickerControllerBackgroundColor = pickerController.view.backgroundColor
        pickerController.view.backgroundColor = .clear
        if let previewViewController = pickerController.previewViewController() {
            self.previewViewController = previewViewController
            previewBackgroundColor = previewViewController.view.backgroundColor
            previewViewController.view.backgroundColor = .clear
            
            let containerView = transitionContext.containerView
            
            backgroundView.frame = containerView.bounds
            backgroundView.backgroundColor = previewBackgroundColor
            containerView.addSubview(backgroundView)
            if let view = pickerController.pickerControllerDelegate?.pickerController?(pickerController, dismissPreviewViewForIndexAt: previewViewController.currentPreviewIndex) {
                toView = view
            }
            
            if let previewCell = previewViewController.getCell(for: previewViewController.currentPreviewIndex) {
                previewCell.scrollContentView?.hiddenOtherSubview()
                beforePreviewFrame = previewCell.frame
                previewView = previewCell
            }
            previewView?.scrollView.clipsToBounds = false
            
            if let previewView = previewView {
                let anchorPoint = CGPoint(x: beganPoint.x / previewView.width, y: beganPoint.y / previewView.height)
                previewView.layer.anchorPoint = anchorPoint
                previewView.frame = pickerController.view.bounds
                previewCenter = previewView.center
                containerView.addSubview(previewView)
            }
            containerView.addSubview(pickerController.view)
            previewViewController.collectionView.isScrollEnabled = false
            previewView?.scrollView.isScrollEnabled = false
            previewView?.scrollView.pinchGestureRecognizer?.isEnabled = false
            toView?.isHidden = true
            beganInterPercent = true
        }
    }
    func resetScrollView(for enabled: Bool) {
        previewViewController?.collectionView.isScrollEnabled = enabled
        previewView?.scrollView.isScrollEnabled = enabled
        previewView?.scrollView.pinchGestureRecognizer?.isEnabled = enabled
        previewView?.scrollView.clipsToBounds = enabled
        if enabled {
            previewViewController?.view.backgroundColor = self.previewBackgroundColor
            pickerController?.view.backgroundColor = self.pickerControllerBackgroundColor
        }
    }
}

