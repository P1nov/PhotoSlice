//
//  PSLongImageSliceCompletedViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

let PSLongImageSliceCompletedCollectionViewCellIdentifier = "PSLongImageSliceCompletedCollectionViewCellIdentifier"

class PSLongImageSliceCompletedViewController: BaseCollectionViewController {

    //MARK: lazyLoad
    var images : [UIImage]?
    
    var finalImage : UIImage?
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存图片", style: .plain, target: self, action: #selector(saveLongImage))
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: Scale(360), height: 10.0)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(PSLongImageSliceCollectionViewCell.self, forCellWithReuseIdentifier: PSLongImageSliceCompletedCollectionViewCellIdentifier)
        
        if images != nil  {
            
            PSImageHandleManager.shared.sliceImage(with: images!) { (image) in
                
                self.finalImage = image
                
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
        
    }
    
    //MARK: action
    @objc private func saveLongImage() {
        
        UIImageWriteToSavedPhotosAlbum(finalImage!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo : AnyObject) {
        
        
    }
    
    //MARK:`deinit`()oc
    deinit {
        removeNotificationObserver()
    }

}

extension PSLongImageSliceCompletedViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if finalImage != nil {
            
            return 1
        }else {
            
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PSLongImageSliceCompletedCollectionViewCellIdentifier, for: indexPath) as! PSLongImageSliceCollectionViewCell
        
        cell.imageView.image = finalImage
        
        return cell
    }
}
