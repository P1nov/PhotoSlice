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
        layout.estimatedItemSize = .init(width: Scale(345), height: 10.0)
        
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
            
            let finalImage = PSImageHandleManager.shared.getAspectFillWidthImage(image1: image, width: Scale(345))
            
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
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Scale(2)
    }
}
