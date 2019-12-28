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
    
    private var photos : PHFetchResult<PHAsset>? {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    private var selectImages : [Int : UIImage]? = [:]
    private var selectAsset : [PHAsset]? = []
    
    private var imageRequeseOptions = PHImageRequestOptions()
    
    var maxSelect : Int = 9
    
    var selectNum : Int = 0

    //MARK: lazyLoad
    
    
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
        
        imageRequeseOptions.isSynchronous = true
        imageRequeseOptions.resizeMode = .fast
        imageRequeseOptions.isNetworkAccessAllowed = false;
        imageRequeseOptions.isSynchronous = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(completeImageSelect))
        
        collectionView.register(PSUserPhotoCollectionViewCell.self, forCellWithReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier)
        
        PNProgressHUD.loading(at: nil)
        
        PSImageHandleManager.shared.getPhotosFromAlbum(album: album!, completion: { (photos) in

            PNProgressHUD.hideLoading(from: nil)

            self.photos = photos
        })
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
    }
    
    //MARK: action
    
    @objc private func completeImageSelect() {
        
        let images = selectImages?.map { it in it.value }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PSImageSelectImageNotificationName), object: nil, userInfo: ["images" : images as Any])
        
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
        cell.selectBtn.tag = indexPath.row
        cell.resource = photos![indexPath.row]
        
        if selectImages![indexPath.row] != nil {
            
            cell.selectBtn.isSelected = true
        }else {
            
            cell.selectBtn.isSelected = false
        }
        
        
        //加载cell上的图片（缩略图）
        DispatchQueue.global().async {
            
            PHImageManager.default().requestImage(for: self.photos![indexPath.row], targetSize: CGSize(width: (kScreenWidth - Scale(5)) / 5.0, height: (kScreenWidth - Scale(5)) / 5.0), contentMode: .aspectFill, options: self.imageRequeseOptions) { (image, info) in
                
                DispatchQueue.main.async {

                    cell.imageView.image = image
                }
            }
        }
        
        //cell上的button点击交互
        cell.didSelectCellImage = { (selected) in
            
            //超出最大选择数
            if !selected && self.selectNum >= self.maxSelect {
                
                PNProgressHUD.present(with: "已超出最大选择数量，不能再选择", presentType: .fromTop, font: .systemFont(ofSize: 14.0, weight: .medium), backgroundColor: UIColor(rgb: 0xFF4B32), textColor: .white, in: nil)
                
                return
            }
            
            //小于最大选择数且选择
            if self.selectNum < self.maxSelect && !selected {
                
                PHImageManager.default().requestImage(for: cell.resource!, targetSize: .zero, contentMode: .aspectFill, options: self.imageRequeseOptions) { (image, info) in
                    
                    if let finalImage = image {
                        
                        self.selectNum += 1
                        
                        self.selectImages![indexPath.row] = finalImage
                    }else {
                        
                        return
                    }
                }
            }
            
            //取消选择图片
            if selected {
                
                self.selectImages?.removeValue(forKey: indexPath.row)
                
                self.selectNum -= 1
            }
            
            cell.selectBtn.isSelected = !selected
        }

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
