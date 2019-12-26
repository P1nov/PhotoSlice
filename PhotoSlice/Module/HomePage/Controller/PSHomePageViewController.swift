//
//  PSHomePageViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

class PSHomePageViewController: BaseCollectionViewController {
    
    private let ListCellIdentifier : String = "ListCellIdentifier"

    //MARK: lazyLoad
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        collectionView.register(PSHomePageListCollectionViewCell.self, forCellWithReuseIdentifier: ListCellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: self.view.bounds.width, height: 10.0)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        super.addNotificationObserver()
        
    }
    
    //MARK: action
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

extension PSHomePageViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCellIdentifier, for: indexPath) as! PSHomePageListCollectionViewCell
        
        cell.avatarImageView.image = UIImage(named: "")
        cell.nameLabel.text = "@P1no"
        cell.browseNumberLabel.text = "1.2M 浏览"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        .init(top: Scale(10), left: 0, bottom: Scale(10), right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Scale(10)
    }
}
