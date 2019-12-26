//
//  PSUserPhotosViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/26.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit
import Photos

private let PSUserPhotoCollectionViewCellIdentifier = "PSUserPhotoCollectionViewCellIdentifier"

class PSUserPhotosViewController: BaseCollectionViewController {
    
    var album : PHAssetCollection?
    
    private var photos : PHFetchResult<PHAsset>?
    
    private var selectImages : [UIImage]? = []

    //MARK: lazyLoad
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(completeImageSelect))
        
        collectionView.register(PSUserPhotoCollectionViewCell.self, forCellWithReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier)
        
        photos = PSImageHandleManager.shared.getPhotosFromAlbum(album: album!)
        
        collectionView.reloadData()
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
    }
    
    //MARK: action
    @objc private func selectImage(button : UIButton) {
        
        let indexPath = IndexPath.init(item: button.tag, section: 0)
        
        let cell = collectionView.cellForItem(at: indexPath) as! PSUserPhotoCollectionViewCell
        
        if button.isSelected {
            
            selectImages?.removeAll(where: { (image) -> Bool in
                
                return image.isEqual(cell.imageView.image)
            })
        }else {
            
            selectImages?.append(cell.imageView.image!)
        }
        
        button.isSelected = !button.isSelected
    }
    
    @objc private func completeImageSelect() {
        
        print(selectImages!.count)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PSImageSelectImageNotificationName), object: nil, userInfo: ["images" : selectImages as Any])
        
        self.navigationController?.setViewControllers([self.navigationController!.viewControllers.first!], animated: true)
    }
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension PSUserPhotosViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier, for: indexPath) as! PSUserPhotoCollectionViewCell
        
        cell.imageView.image = UIImage.image(with: .orange)
        
        DispatchQueue.global().async {
            
            PHImageManager.default().requestImageData(for: self.photos!.object(at: indexPath.row), options: nil) { (imageData, string, orientation, info) in
                
                DispatchQueue.main.async {
                    
                    if imageData != nil {
                        
                        cell.imageView.image = UIImage.init(data: imageData!)
                    }
                }
            }
        }
        
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(selectImage(button:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        .init(width: (kScreenWidth - Scale(5)) / 4, height: (kScreenWidth - Scale(5)) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Scale(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        Scale(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        .init(top: Scale(1), left: Scale(1), bottom: Scale(1), right: Scale(1))
    }
}
