//
//  PSImageShotViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/6.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

class PSImageShotViewController: BaseViewController {

    //MARK: lazyLoad
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
        
    }()
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: UISet
    
    override var preferredContentSize: CGSize {
        
        get {
            
            return .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        set(contentSize) {
            
            
        }
    }
    
    override func configUISet() {
        super.configUISet()
        
        self.view.backgroundColor = .clear
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
            
            make.width.equalToSuperview().multipliedBy(0.8)
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

extension PSImageShotViewController {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
