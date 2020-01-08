//
//  PSImageFilterViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/7.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

let PSImageFilterCollectionViewCellIdentifier = "PSImageFilterCollectionViewCellIdentifier"

class PSImageFilterViewController: BaseCollectionViewController {
    
    let dict : Dictionary<String, String> = ["方框模糊" : "CIBoxBlur", "彩色调整" : "CIColorClamp", "凹凸变形" : "CIBumpDistortion", "动画模糊" : "CIMotionBlur", "缩放模糊" : "CIZoomBlur", "重度模糊" : "CIDiscBlur", "亮度调整" : "CIColorControls"]
    let array : Array<String> = ["方框模糊", "彩色调整", "凹凸变形", "动画模糊", "缩放模糊", "重度模糊", "亮度调整"]
    
    var completion : ((_ filter : CIFilter) -> Void)?

    //MARK: lazyLoad
    
    //MARK: lifeCycle
    convenience init(completion : ((_ filter : CIFilter) -> Void)?) {
        self.init()
        
        self.completion = completion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override var preferredContentSize: CGSize {
        
        get {
            
            return .init(width: UIScreen.main.bounds.width, height: Scale(100))
        }
        set(contentSize) {
            
            
        }
    }
    //MARK: UISet
    override func configUISet() {
        super.configUISet()
        
        collectionView.register(PSImageFilterCollectionViewCell.self, forCellWithReuseIdentifier: PSImageFilterCollectionViewCellIdentifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(closeFilterSelect))
        self.navigationController?.navigationBar.set(backgroundColor: .black, tintColor: .white, isShowShadow: false)
        
        self.collectionView.backgroundColor = .black
        self.view.backgroundColor = .black
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
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

extension PSImageFilterViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        array.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PSImageFilterCollectionViewCellIdentifier, for: indexPath) as! PSImageFilterCollectionViewCell
        
        cell.titleLabel.text = dict[array[indexPath.row]]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            
            let filter = CIFilter.init(name: self.dict[self.array[indexPath.row]]!)!
            
            if self.dict[self.array[indexPath.row]]!.elementsEqual("CIColorControls") {
                
                filter.setValue(0.5, forKey: kCIInputBrightnessKey)
                filter.setValue(1.2, forKey: kCIInputSaturationKey)
                filter.setValue(3.1, forKey: kCIInputContrastKey)
            }else if self.dict[self.array[indexPath.row]]!.elementsEqual("CIColorClamp") {
                
                let min = CIVector.init(x: 0.1, y: 0, z: 0.1, w: 0)
                let max = CIVector.init(x: 0.6, y: 1, z: 0.6, w: 1)
                
                filter.setValue(min, forKey: "inputMinComponents")
                filter.setValue(max, forKey: "inputMaxComponents")
            }
            
            self.completion!(filter)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        .init(width: Scale(80), height: Scale(80))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
}

@objc
private extension PSImageFilterViewController {
    
    func closeFilterSelect() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
