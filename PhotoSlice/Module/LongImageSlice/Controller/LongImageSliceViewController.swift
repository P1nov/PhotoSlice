//
//  LongImageSliceViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import Photos

private let PSLongImageSliceCollectionViewCellIdentifier = "PSLongImageSliceCollectionViewCellIdentifier"

class LongImageSliceViewController: BaseCollectionViewController {
    
    private var selectAssets : [UIImage : PHAsset] = [:]
    var selectedImages : [UIImage]? = []
    
    var isOperated : Bool = false
    
    var currentIndexPath : IndexPath?
    var currentCell : PSLongImageSliceCollectionViewCell?
    var changedCell : PSLongImageSliceCollectionViewCell?
    
     var changeView : UIView?
    
    var firstImage : UIImage?
    var lastImage : UIImage?

    //MARK: lazyLoad
    lazy var toolBar: PSImageToolBar = {
        let toolBar = PSImageToolBar.init(frame: CGRect(x: 0, y: self.view.frame.height - (Scale(50) + kSafeBottomHeight()), width: self.view.frame.width, height: Scale(50) + kSafeBottomHeight()))
        
        toolBar.confirmButton.addTarget(self, action: #selector(completeSliceImage), for: .touchUpInside)
        toolBar.previewButton.isHidden = true
        
        return toolBar
    }()
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.set(backgroundColor: .white, tintColor: .black, isShowShadow: false)
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: collectionView.bounds.width, height: 10.0)
        
        collectionView.collectionViewLayout = layout
        
        self.setNavTitle(string: "长图拼接", font: UIFont.systemFont(ofSize: 16.0, weight: .medium))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(closeSlice))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "选择照片", style: .plain, target: self, action: #selector(toUserAlbum))
        
        collectionView.register(PSLongImageSliceCollectionViewCell.self, forCellWithReuseIdentifier: PSLongImageSliceCollectionViewCellIdentifier)
        
        collectionView.reloadData()
        
        self.view.addSubview(toolBar)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(handle(longPress:)))
        
        collectionView.addGestureRecognizer(longPress)
        
        updateToolBarState()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - toolBar.frame.height - kSafeBottomHeight())
        toolBar.frame = CGRect(x: 0, y: collectionView.frame.height, width: self.view.frame.width, height: Scale(50) + kSafeBottomHeight())
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        super.addNotificationObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(completedImageSelect(notification:)), name: NSNotification.Name(rawValue: PSImageSelectImageNotificationName), object: nil)
    }
    
    @objc private func completedImageSelect(notification : Notification) {
        
        let images = notification.userInfo!["images"] as! [UIImage]
        let assets = notification.userInfo!["assets"] as! [UIImage : PHAsset]
        
        selectedImages = images
        selectAssets = assets
        
        selectedImages = selectedImages?.map({ (image) -> UIImage in
            
            let finalImage = PSImageHandleManager.shared.getAspectFillWidthImage(image1: image, width: Scale(290))
            
            return finalImage
        })
        
        collectionView.reloadData()
        
        updateToolBarState()
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension LongImageSliceViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        selectedImages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PSLongImageSliceCollectionViewCellIdentifier, for: indexPath) as! PSLongImageSliceCollectionViewCell
        
        cell.imageView.image = selectedImages![indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.image = selectedImages![indexPath.row]
        
        cell.deleteImageCallBack = {
            
            self.selectAssets.removeValue(forKey: self.selectedImages![indexPath.row])
            self.selectedImages?.remove(at: indexPath.row)
            
            collectionView.reloadData()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Scale(2)
    }
    
    
}

@objc
private extension LongImageSliceViewController {
    
    private func handle(longPress : UILongPressGestureRecognizer) {
        
        switch longPress.state {
        case .began:
            
            currentIndexPath = collectionView.indexPathForItem(at: longPress.location(in: collectionView))
            
            guard let indexPath = collectionView.indexPathForItem(at: longPress.location(in: collectionView)) else {
                
                return
            }
            
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            currentCell = (collectionView.cellForItem(at: indexPath) as! PSLongImageSliceCollectionViewCell)
            changeView = currentCell?.snapshotView(afterScreenUpdates: true)
            changeView?.alpha = 0.0
            changeView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            self.collectionView.addSubview(changeView!)
            
            UIView.animate(withDuration: 0.2) {
                
                self.changeView?.alpha = 0.6
                self.changeView?.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            }
            
            currentCell?.layer.removeAnimation(forKey: "shake")
        case .changed:
            
            changeView!.center = longPress.location(in: self.collectionView)
            collectionView.updateInteractiveMovementTargetPosition(longPress.location(in: collectionView))
            
            guard let changedIndexPath = collectionView.indexPathForItem(at: longPress.location(in: self.collectionView)) else {
                
                return
            }
            
            if changedCell != nil {
                
                changedCell?.contentView.layer.borderWidth = 0
                changedCell?.contentView.layer.borderColor = UIColor.clear.cgColor
            }
            
            guard let currentCell = collectionView.cellForItem(at: changedIndexPath) else {
                
                return
            }
            
            changedCell = (currentCell as! PSLongImageSliceCollectionViewCell)
            
            changedCell?.contentView.layer.borderWidth = Scale(2)
            changedCell?.contentView.layer.borderColor = UIColor(rgb: 0xFF4B32).cgColor
            
            if collectionView.contentOffset.y < collectionView.contentSize.height && longPress.location(in: self.view).y >= self.view.frame.height - 30 {
                
                if collectionView.contentOffset.y + 30 >= collectionView.contentSize.height {
                    
                    collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentSize.height), animated: true)
                }else {
                    
                    collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y + 30), animated: true)
                }
                
                
            }else if collectionView.contentOffset.y > 0 && longPress.location(in: self.view).y <= 30 {
                
                if collectionView.contentOffset.y <= 30 {
                    
                    collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }else {
                    
                    collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y - 30), animated: true)
                }
            }
            
            break
        case .ended:
            
            collectionView.endInteractiveMovement()
            
            let endIndexPath = collectionView.indexPathForItem(at: longPress.location(in: self.collectionView))
            
            (selectedImages![currentIndexPath!.item], selectedImages![endIndexPath!.item]) = (selectedImages![endIndexPath!.item], selectedImages![currentIndexPath!.item])
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.changeView?.alpha = 0.0
                self.changeView?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            }) { (completed) in
                
                self.changeView?.removeFromSuperview()
                
                self.currentCell?.imageView.image = self.selectedImages![self.currentIndexPath!.item]
                
                let endCell = self.collectionView.cellForItem(at: endIndexPath!) as! PSLongImageSliceCollectionViewCell
                endCell.imageView.image = self.selectedImages![endIndexPath!.item]
                endCell.contentView.layer.borderWidth = 0
                
            }
            
            break
        default:
            break
        }
    }
    
    private func closeSlice() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func toUserAlbum() {
        
        let controller = PSUserPhotosViewController()
        controller.maxSelect = 9
        controller.selectAssets = self.selectAssets
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func completeSliceImage() {
        
        if selectedImages!.count > 0 {
            
            let controller = PSLongImageSliceCompletedViewController(finalImages: selectedImages!)
            
            self.navigationController?.pushViewController(controller, animated: true)
        }else {
            
            PNProgressHUD.present(with: "您还未选择图片",
                                  presentType: .fromTop,
                                  font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                                  backgroundColor: UIColor(rgb: 0xFF4B32),
                                  textColor: .white,
                                  in: nil)
        }
        
    }
    
    func updateToolBarState() {
        
        if selectedImages!.count > 0 {
            
            toolBar.confirmButton.isEnabled = true
        }else {
            
            toolBar.confirmButton.isEnabled = false
        }
        
        toolBar.confirmButton.setTitle("完成", for: .normal)
    }
    
}
