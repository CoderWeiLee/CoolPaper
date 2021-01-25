//
//  HXPHPickerViewController+SwipeSelect.swift
//  HXPHPicker
//
//  Created by Slience on 2020/12/31.
//

import UIKit

// MARK: 滑动选择
extension HXPHPickerViewController {
    
    @objc func panGestureRecognizer(panGR: UIPanGestureRecognizer) {
        if titleView.isSelected {
            return
        }
        let localPoint = panGR.location(in: collectionView)
        swipeSelectLastLocalPoint = panGR.location(in: view)
        switch panGR.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: localPoint), let photoAsset = getCell(for: indexPath.item)?.photoAsset, let pickerController = pickerController {
                if !pickerController.canSelectAsset(for: photoAsset, showHUD: false) && !photoAsset.isSelected {
                    return
                }
                swipeSelectedIndexArray = []
                swipeSelectBeganIndexPath = collectionView.indexPathForItem(at: localPoint)
                swipeSelectState = photoAsset.isSelected ? .unselect : .select
                updateCellSelectedState(for: indexPath.item, isSelected: swipeSelectState == .select)
                swipeSelectedIndexArray?.append(indexPath.item)
                swipeSelectAutoScroll()
            }
            break
        case .changed:
            let lastIndexPath = collectionView.indexPathForItem(at: localPoint)
            if let lastIndex = lastIndexPath?.item, let lastIndexPath = lastIndexPath {
                if let beganIndex = swipeSelectBeganIndexPath?.item, let swipeSelectState = swipeSelectState, let indexArray = swipeSelectedIndexArray {
                    if swipeSelectState == .select {
                        if let lastPhotoAsset = pickerController?.selectedAssetArray.last, let cellIndexPath = getIndexPath(for: lastPhotoAsset) {
                            if lastIndex < beganIndex && cellIndexPath.item < lastIndex {
                                for index in cellIndexPath.item...lastIndex {
                                    if indexArray.contains(index) {
                                        updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                        let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                        swipeSelectedIndexArray?.remove(at: firstIndex)
                                    }
                                }
                            }else if lastIndex > beganIndex && cellIndexPath.item > lastIndex {
                                for index in lastIndex...cellIndexPath.item {
                                    if indexArray.contains(index) {
                                        updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                        let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                        swipeSelectedIndexArray?.remove(at: firstIndex)
                                    }
                                }
                            }else {
                                for index in indexArray {
                                    if lastIndex <= beganIndex && index > beganIndex {
                                        updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                        let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                        swipeSelectedIndexArray?.remove(at: firstIndex)
                                    }else if lastIndex >= beganIndex && index < beganIndex {
                                        updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                        let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                        swipeSelectedIndexArray?.remove(at: firstIndex)
                                    }
                                }
                            }
                        }
                    }else {
                        for index in indexArray {
                            if lastIndex < beganIndex {
                                if index < lastIndex || index > beganIndex {
                                    updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                    let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                    swipeSelectedIndexArray?.remove(at: firstIndex)
                                }
                            }else if lastIndex > beganIndex {
                                if index > lastIndex || index < beganIndex {
                                    updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                    let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                    swipeSelectedIndexArray?.remove(at: firstIndex)
                                }
                            }else {
                                updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                swipeSelectedIndexArray?.remove(at: firstIndex)
                            }
                        }
                    }
                    if beganIndex > lastIndex {
                        var index = beganIndex
                        while index >= lastIndex {
                            panGRChangedUpdateState(index: index, state: swipeSelectState)
                            index -= 1
                        }
                    }else if beganIndex < lastIndex {
                        for index in beganIndex ... lastIndex {
                            panGRChangedUpdateState(index: index, state: swipeSelectState)
                        }
                    }else {
                        panGRChangedUpdateState(index: beganIndex, state: swipeSelectState)
                    }
                    updateCellSelectedTitle()
                }else {
                    if let photoAsset = getCell(for: lastIndex)?.photoAsset, let pickerController = pickerController {
                        if !pickerController.canSelectAsset(for: photoAsset, showHUD: false) && !photoAsset.isSelected {
                            return
                        }
                        swipeSelectedIndexArray = []
                        swipeSelectBeganIndexPath = lastIndexPath
                        swipeSelectState = photoAsset.isSelected ? .unselect : .select
                        updateCellSelectedState(for: lastIndex, isSelected: swipeSelectState == .select)
                        swipeSelectedIndexArray?.append(lastIndex)
                        swipeSelectAutoScroll()
                    }
                }
            }else {
                if let beganIndex = swipeSelectBeganIndexPath?.item, let swipeSelectState = swipeSelectState, let indexArray = swipeSelectedIndexArray, let point = swipeSelectLastLocalPoint {
                    let largeHeight = collectionView.contentSize.height > collectionView.height
                    var exceedBottom: Bool
                    let offsety = self.collectionView.contentOffset.y
                    let maxOffsetY = collectionView.contentSize.height - collectionView.height + collectionView.contentInset.bottom - 1
                    if offsety > maxOffsetY {
                        exceedBottom = largeHeight ? point.y > collectionView.height - collectionView.contentInset.bottom - 1 - collectionViewLayout.itemSize.height : localPoint.y > collectionView.contentSize.height - 1 - collectionViewLayout.itemSize.height
                    }else {
                        exceedBottom = largeHeight ? false : localPoint.y > collectionView.contentSize.height - 1 - collectionViewLayout.itemSize.height
                    }
                    let inScope = point.x >= 0 && point.x <= collectionView.width
                    if exceedBottom && inScope {
                        for index in indexArray {
                            if index < beganIndex {
                                updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                swipeSelectedIndexArray?.remove(at: firstIndex)
                            }
                        }
                        let endIndex = needOffset ? assets.count : assets.count - 1
                        for index in beganIndex ... endIndex {
                            panGRChangedUpdateState(index: index, state: swipeSelectState)
                        }
                    }else if localPoint.y < 0 && inScope {
                        for index in indexArray {
                            if index > beganIndex {
                                updateCellSelectedState(for: index, isSelected: !(swipeSelectState == .select))
                                let firstIndex = swipeSelectedIndexArray!.firstIndex(of: index)!
                                swipeSelectedIndexArray?.remove(at: firstIndex)
                            }
                        }
                        for index in 0 ... beganIndex {
                            panGRChangedUpdateState(index: index, state: swipeSelectState)
                        }
                    }
                }
            }
            break
        case .ended, .cancelled, .failed:
            clearSwipeSelectData()
            break
        default:
            break
        }
    }
    func clearSwipeSelectData() {
        swipeSelectAutoScrollTimer?.cancel()
        swipeSelectAutoScrollTimer = nil
        swipeSelectBeganIndexPath = nil
        swipeSelectState = nil
        swipeSelectedIndexArray = nil
    }
    func panGRChangedUpdateState(index: Int, state: HXPHPickerViewControllerSwipeSelectState) {
        if index >= assets.count && !needOffset {
            return
        }
        let photoAsset = getPhotoAsset(for: index)
        if swipeSelectState == .select {
            if let array = swipeSelectedIndexArray, !photoAsset.isSelected,  !array.contains(index) {
                swipeSelectedIndexArray?.append(index)
            }
        }else {
            if let array = swipeSelectedIndexArray, photoAsset.isSelected, !array.contains(index) {
                swipeSelectedIndexArray?.append(index)
            }
        }
        updateCellSelectedState(for: index, isSelected: state == .select)
    }
    func swipeSelectAutoScroll() {
        if !config.swipeSelectAllowAutoScroll {
            return
        }
        swipeSelectAutoScrollTimer = DispatchSource.makeTimerSource()
        swipeSelectAutoScrollTimer?.schedule(deadline: .now() + .milliseconds(250), repeating: .milliseconds(250), leeway: .microseconds(0))
        swipeSelectAutoScrollTimer?.setEventHandler(handler: {
            DispatchQueue.main.async {
                self.startAutoScroll()
            }
        })
        swipeSelectAutoScrollTimer?.resume()
    }
    func startAutoScroll() {
        if let localPoint = swipeSelectLastLocalPoint {
            let topRect = CGRect(x: 0, y: 0, width: view.width, height: config.autoSwipeTopAreaHeight + collectionView.contentInset.top)
            let bottomRect = CGRect(x: 0, y: collectionView.height - collectionView.contentInset.bottom - config.autoSwipeBottomAreaHeight, width: view.width, height: config.autoSwipeBottomAreaHeight + collectionView.contentInset.bottom)
            let margin: CGFloat = 140 * config.swipeSelectScrollSpeed
            var offsety: CGFloat
            if topRect.contains(localPoint) {
                offsety = self.collectionView.contentOffset.y - margin
                if offsety < -collectionView.contentInset.top {
                    offsety = -collectionView.contentInset.top
                }
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
                    self.collectionView.contentOffset = CGPoint(x: self.collectionView.contentOffset.x, y: offsety)
                } completion: { (isFinished) in
                }
            }else if bottomRect.contains(localPoint) {
                offsety = self.collectionView.contentOffset.y + margin
                let maxOffsetY = collectionView.contentSize.height - collectionView.height + collectionView.contentInset.bottom
                if offsety > maxOffsetY {
                    offsety = maxOffsetY
                }
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
                    self.collectionView.contentOffset = CGPoint(x: self.collectionView.contentOffset.x, y: offsety)
                } completion: { (isFinished) in
                }
            }
            panGestureRecognizer(panGR: swipeSelectPanGR!)
        }
    }
    
    func updateCellSelectedState(for item: Int, isSelected: Bool) {
        if item >= assets.count && !needOffset {
            return
        }
        var showHUD = false
        if let pickerController = pickerController {
            let photoAsset = getPhotoAsset(for: item)
            if photoAsset.isSelected != isSelected {
                if isSelected {
                    if pickerController.canSelectAsset(for: photoAsset, showHUD: false) {
                        _ = pickerController.addedPhotoAsset(photoAsset: photoAsset)
                        if let cell = getCell(for: item) {
                            cell.updateSelectedState(isSelected: isSelected, animated: false)
                        }
                    }else {
                        showHUD = true
                    }
                }else {
                    _ = pickerController.removePhotoAsset(photoAsset: photoAsset)
                    if let cell = getCell(for: item) {
                        cell.updateSelectedState(isSelected: isSelected, animated: false)
                    }
                }
            }
            bottomView.updateFinishButtonTitle()
        }
        if pickerController!.selectArrayIsFull() && showHUD {
            swipeSelectPanGR?.isEnabled = false
            HXPHProgressHUD.showWarningHUD(addedTo: navigationController?.view, text: String.init(format: "已达到最大选择数".localized, arguments: [pickerController!.config.maximumSelectedPhotoCount]), animated: true, delay: 1.5)
            clearSwipeSelectData()
            swipeSelectPanGR?.isEnabled = true
        }
    }
}
