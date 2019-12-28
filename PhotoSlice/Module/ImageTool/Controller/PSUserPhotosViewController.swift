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
    
    private var resource : (PHFetchResult<PHAsset>, PHFetchResult<PHAssetCollection>, PHFetchResult<PHCollection>)?
    
    private var images : [UIImage]? {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    private var selectImages : [Int : UIImage]? = [:]
    var selectAssets : [Int : PHAsset]? = [:]
    
    private var imageRequeseOptions = PHImageRequestOptions()
    
    var maxSelect : Int = 9
    
    var selectNum : Int = 0

    //MARK: lazyLoad
    lazy var toolBar: PSImageToolBar = {
        let toolBar = PSImageToolBar.init(frame: CGRect(x: 0, y: self.view.frame.height - (Scale(50) + kSafeBottomHeight()), width: self.view.frame.width, height: Scale(50) + kSafeBottomHeight()))
        
        toolBar.confirmButton.addTarget(self, action: #selector(completeImageSelect), for: .touchUpInside)
        toolBar.previewButton.isHidden = true
        
        return toolBar
    }()
    
    //MARK: lifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - toolBar.frame.height - kSafeBottomHeight())
        toolBar.frame = CGRect(x: 0, y: collectionView.frame.height, width: self.view.frame.width, height: Scale(50) + kSafeBottomHeight())
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        self.view.addSubview(toolBar)
        
        imageRequeseOptions.isSynchronous = true
        imageRequeseOptions.resizeMode = .fast
        imageRequeseOptions.isNetworkAccessAllowed = false;
        imageRequeseOptions.isSynchronous = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "前往相册", style: .plain, target: self, action: #selector(gotoAlbum))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(closeCurrent))
        
        collectionView.register(PSUserPhotoCollectionViewCell.self, forCellWithReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier)
        
        PNProgressHUD.loading(at: nil)
        
        DispatchQueue.global().async {
            
            PSImageHandleManager.shared.getRealImageFromAssets { (images, resource) in
                
                DispatchQueue.main.async {
                    
                    PNProgressHUD.hideLoading(from: nil)
                    
                    self.images = images
                    self.resource = resource
                    
                    self.updateToolBarState()
                }
            }
        }
        
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
    }
    
    //MARK: action
    
    
    
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
        
        images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PSUserPhotoCollectionViewCellIdentifier, for: indexPath) as! PSUserPhotoCollectionViewCell
        
        cell.imageView.image = UIImage.image(with: .orange)
        cell.resource = resource?.0[indexPath.row]
        
        if selectImages![indexPath.row] != nil {
            
            cell.selectBtn.isSelected = true
        }else {
            
            cell.selectBtn.isSelected = false
        }
        
        if selectAssets![indexPath.row] != nil {
            
            cell.selectBtn.isSelected = true
        }else {
            
            cell.selectBtn.isSelected = false
        }
        
        //加载cell上的图片（缩略图）
        cell.imageView.image = images![indexPath.row]
        
        //cell上的button点击交互
        cell.didSelectCellImage = { (selected) in
            
            //超出最大选择数
            if !selected && self.selectNum >= self.maxSelect {
                
                PNProgressHUD.present(with: "已超出最大选择数量，不能再选择", presentType: .fromTop, font: .systemFont(ofSize: 14.0, weight: .medium), backgroundColor: UIColor(rgb: 0xFF4B32), textColor: .white, in: nil)
                
                return
            }
            
            //小于最大选择数且选择
            if self.selectNum < self.maxSelect && !selected {
                
                self.selectNum += 1
                
                self.selectAssets![indexPath.row] = cell.resource
            }
            
            //取消选择图片
            if selected {
                self.selectAssets?.removeValue(forKey: indexPath.row)
                
                self.selectNum -= 1
            }
            
            cell.selectBtn.isSelected = !selected
            
            self.updateToolBarState()
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

@objc
private extension PSUserPhotosViewController {
    
    func closeCurrent() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func completeImageSelect() {
        
        PNProgressHUD.loading(at: nil)
        
        DispatchQueue.global().sync {
            
            let assets = selectAssets?.map { it in it.value }
            
            if let currentAssets = assets {
                
                PSImageHandleManager.shared.getImageFromAssets(options : self.imageRequeseOptions,
                                                               assets: currentAssets ) { (images) in
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PSImageSelectImageNotificationName),
                                                        object: nil,
                                                        userInfo: ["images" : images as Any, "assets" : self.selectAssets as Any])
                        
                        PNProgressHUD.hideLoading(from: nil)
                        
                        self.navigationController?.setViewControllers([self.navigationController!.viewControllers.first!], animated: true)
                    }
                    
                }
            }else {
                
                PNProgressHUD.hideLoading(from: nil)
                
                PNProgressHUD.present(with: "出现异常！请稍后重试~",
                                      presentType: .fromTop,
                                      font: .systemFont(ofSize: 14.0, weight: .medium),
                                      backgroundColor: UIColor(rgb: 0xFF4B32),
                                      textColor: .white, in: nil)
                
                return
            }
            
        }
    }
    
    func gotoAlbum() {
        
        PNProgressHUD.loading(at: nil)
        
        PSImageHandleManager.shared.getUserAlbums { (albums) in
            
            PNProgressHUD.hideLoading(from: nil)
            
            let controller = PSUserAlbumViewController()
            controller.userAlbums = albums
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func updateToolBarState() {
        
        if selectNum == 0 {
            
            toolBar.confirmButton.isEnabled = false
        }else {
            
            toolBar.confirmButton.isEnabled = true
        }
        
        var confirmTitle = "确认" + "(\(selectNum)/\(maxSelect))"
        toolBar.confirmButton.setTitle(confirmTitle, for: .normal)
        
        guard let assets = selectAssets else {
            
            return
        }
        
        selectNum = assets.keys.count
        confirmTitle = "确认" + "(\(selectNum)/\(maxSelect))"
        toolBar.confirmButton.setTitle(confirmTitle, for: .normal)
        
        if selectNum == 0 {
            
            toolBar.confirmButton.isEnabled = false
        }else {
            
            toolBar.confirmButton.isEnabled = true
        }
    }
}
