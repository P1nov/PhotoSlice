//
//  LongImageSliceViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

private let PSLongImageSliceCollectionViewCellIdentifier = "PSLongImageSliceCollectionViewCellIdentifier"

class LongImageSliceViewController: BaseCollectionViewController {
    
    var isOperated : Bool = false
    
    var currentIndexPath : IndexPath?
    var currentCell : PSLongImageSliceCollectionViewCell?
    var changedCell : PSLongImageSliceCollectionViewCell?
    
     var changeView : UIView?
    
    var firstImage : UIImage?
    var lastImage : UIImage?

    //MARK: lazyLoad
    var selectedImages : [UIImage]?
    
    lazy var completeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "complete_slice"), for: .normal)
        button.addTarget(self, action: #selector(completeSliceImage), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: collectionView.bounds.width, height: 10.0)
        
        collectionView.collectionViewLayout = layout
        
        self.setNavTitle(string: "长图拼接", font: UIFont.systemFont(ofSize: 16.0, weight: .medium))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(closeSlice))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "前往相册", style: .plain, target: self, action: #selector(toUserAlbum))
        
        collectionView.register(PSLongImageSliceCollectionViewCell.self, forCellWithReuseIdentifier: PSLongImageSliceCollectionViewCellIdentifier)
        
        collectionView.reloadData()
        
        self.view.addSubview(completeButton)
        
        completeButton.snp.makeConstraints { (make) in
            
            make.right.bottom.equalToSuperview().offset(-Scale(15))
            make.width.height.equalTo(Scale(30))
        }
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(handle(longPress:)))
        
        collectionView.addGestureRecognizer(longPress)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        super.addNotificationObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(completedImageSelect(notification:)), name: NSNotification.Name(rawValue: PSImageSelectImageNotificationName), object: nil)
    }
    
    @objc private func completedImageSelect(notification : Notification) {
        
        let images = notification.userInfo!["images"] as! [UIImage]
        
        selectedImages = images
        
        selectedImages = selectedImages?.map({ (image) -> UIImage in
            
            let finalImage = PSImageHandleManager.shared.getAspectFillWidthImage(image1: image, width: Scale(290))
            
            return finalImage
        })
        
        collectionView.reloadData()
    }
    
    //MARK: action
    @objc private func closeSlice() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func toUserAlbum() {
        
        self.navigationController?.pushViewController(PSUserAlbumViewController(), animated: true)
    }
    
    @objc private func completeSliceImage() {
        
        let controller = PSLongImageSliceCompletedViewController()
        controller.images = selectedImages
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func handle(longPress : UILongPressGestureRecognizer) {
        
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
            
            let changedIndexPath = collectionView.indexPathForItem(at: longPress.location(in: self.collectionView))
            
            if changedCell != nil {
                
                changedCell?.contentView.layer.borderWidth = 0
                changedCell?.contentView.layer.borderColor = UIColor.clear.cgColor
            }
            
            changedCell = (collectionView.cellForItem(at: changedIndexPath!) as! PSLongImageSliceCollectionViewCell)
            
            
            
            changedCell?.contentView.layer.borderWidth = Scale(2)
            changedCell?.contentView.layer.borderColor = UIColor(rgb: 0xFF4B32).cgColor
            
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
                
            }
            
            break
        default:
            break
        }
    }
    
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
        cell.deleteButton.addTarget(self, action: #selector(deleteItem(button:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        cell.image = selectedImages![indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Scale(2)
    }
    
    @objc private func deleteItem(button : UIButton) {
        
        selectedImages?.remove(at: button.tag)
        
        collectionView.reloadData()
    }
    
}
