//
//  PSImageShotViewController.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/6.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

class PSImageShotViewController: BaseViewController {
    
    var originalImage: UIImage? {
        
        didSet {
            
            self.imageView.image = self.originalImage
        }
    }
    
    private lazy var clampView : PSImageColorControlView = {
        
        let view = PSImageColorControlView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 190 + 2 * kSafeBottomHeight()))
        view.colorDelegate = self
        
        return view
    }()

    //MARK: lazyLoad
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
        
    }()
    
    private lazy var toolBar: PSImageEditToolBar = {
        let toolBar = PSImageEditToolBar.init(frame: CGRect(x: 0, y: self.view.bounds.height - Scale(64) - kSafeBottomHeight(), width: self.view.bounds.width, height: Scale(64) + kSafeBottomHeight()))
        toolBar.editDelegate = self
        
        return toolBar
    }()
    
    
    //MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    convenience init(originalImage : UIImage) {
        
        self.init()
        
        self.originalImage = originalImage
    }
    
    //MARK: UISet
    
    override var preferredContentSize: CGSize {
        
        get {
            
            return .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        set(contentSize) {
            
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        toolBar.frame = CGRect(x: 0, y: self.view.bounds.height - Scale(64) - kSafeBottomHeight(), width: self.view.bounds.width, height: Scale(64) + kSafeBottomHeight())
    }
    
    override func configUISet() {
        super.configUISet()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(closeEdit))
        self.navigationController?.navigationBar.set(backgroundColor: .clear, tintColor: .white, isShowShadow: false)
        
        self.view.backgroundColor = .clear
        self.view.addSubview(imageView)
        self.view.addSubview(toolBar)
        
        imageView.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Scale(30))
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    //MARK: delegate & dataSource
    
    //MARK: notification & observer
    override func addNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(completeImageSelect(notification:)), name: Notification.Name(rawValue: PSImageSelectImageNotificationName), object: nil)
    }
    
    //MARK: action
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.clampView.alpha = 0.0
            self.clampView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 190 + 2 * kSafeBottomHeight())
        }) { (completed) in
            
            self.clampView.removeFromSuperview()
        }
    }
    
    //MARK: dealloc
    deinit {
        removeNotificationObserver()
    }

}

@objc
private extension PSImageShotViewController {
    
    func completeImageSelect(notification : Notification) {
        
        let images = notification.userInfo!["images"] as! [[Int :UIImage]]
        
        if var targetImage = images.first?.values.first {
            
            targetImage = PSImageHandleManager.shared.getAspectFillWidthImage(image1: targetImage, width: self.view.bounds.width * 0.8)
            
            let darkenFilter = CIFilter.init(name: "CIDarkenBlendMode")
            let originalCiImage = CIImage(image: originalImage!)
            let targetCiImage = CIImage(image: targetImage)
            darkenFilter?.setValue(originalCiImage, forKey: kCIInputImageKey)
            darkenFilter?.setValue(targetCiImage, forKey: kCIInputBackgroundImageKey)
            
            if let ciImage : CIImage = darkenFilter?.outputImage {
                            
                let ciContext = CIContext.init()
                
                var extent : CGRect = .zero

                extent = ciImage.extent
                
                let cgImage = ciContext.createCGImage(ciImage, from: extent)
                
                let image = UIImage.init(cgImage: cgImage!)
                
                self.imageView.image = image
            }
        }
    }
    
    func closeEdit() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentClampView() {
        
        self.view.addSubview(self.clampView)
        self.clampView.mode = .clamp
        clampView.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.clampView.alpha = 1.0
            self.clampView.frame = CGRect(x: 0, y: self.view.bounds.height - 190 - 2 * kSafeBottomHeight(), width: self.view.bounds.width, height: 190 + 2 * kSafeBottomHeight())
        }) { (completed) in
            
        }
    }
    
    func presentControlView() {
        
        self.view.addSubview(self.clampView)
        self.clampView.mode = .control
        clampView.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.clampView.alpha = 1.0
            self.clampView.frame = CGRect(x: 0, y: self.view.bounds.height - 190 - 2 * kSafeBottomHeight(), width: self.view.bounds.width, height: 190 + 2 * kSafeBottomHeight())
        }) { (completed) in
            
        }
    }
    
}

extension PSImageShotViewController : PSImageEditDelegate, PSImageColorControlDelegate {
    
    func filterEdit() {
        
        self.customPresent(viewController: PSImageFilterViewController(completion: { (filter) in
            
            let ciImage1 = CIImage(image: self.originalImage!)
            
            filter.setValue(ciImage1, forKey: kCIInputImageKey)
            
            if let ciImage = filter.outputImage {
                
                let ciContext = CIContext.init()
                
                var extent : CGRect = .zero
                
//                if filter.name.elementsEqual("CIColorClamp") {
//
//                    extent = CGRect(origin: .zero, size: self.originalImage!.size)
//                }else {
//
//                    extent = ciImage.extent
//                }
                
                extent = ciImage.extent
                
                let cgImage = ciContext.createCGImage(ciImage, from: extent)
                
                let image = UIImage.init(cgImage: cgImage!)
                
                self.imageView.image = image
            }
            
        }))
    }
    
    func colorClamp() {
        
        presentClampView()
    }
    
    func colorControl() {
        
        presentControlView()
    }
    
    func adjustImageColor(x: CGFloat, y: CGFloat, z: CGFloat, w: CGFloat) {
        
        let colorFilter = CIFilter.init(name: "CIColorClamp")
        
        let ciImage1 = CIImage(image: originalImage!)
        
        colorFilter?.setValue(ciImage1, forKey: kCIInputImageKey)
        colorFilter?.setValue(CIVector.init(x: x, y: y, z: z, w: w), forKey: "inputMinComponents")
        colorFilter?.setValue(CIVector.init(x: 0.6, y: 1, z: 0.6, w: 1), forKey: "inputMaxComponents")
        
        if let ciImage : CIImage = colorFilter?.outputImage {
                        
            let ciContext = CIContext.init()
            
            var extent : CGRect = .zero

            extent = ciImage.extent
            
            let cgImage = ciContext.createCGImage(ciImage, from: extent)
            
            let image = UIImage.init(cgImage: cgImage!)
            
            self.imageView.image = image
        }
    }
    
    func adjustImageColorControl(x: CGFloat, y: CGFloat, z: CGFloat) {
        
        let colorFilter = CIFilter.init(name: "CIColorControls")
        
        let ciImage1 = CIImage(image: originalImage!)
        
        colorFilter?.setValue(ciImage1, forKey: kCIInputImageKey)
        colorFilter?.setValue(x, forKey: kCIInputBrightnessKey)
        colorFilter?.setValue(y, forKey: kCIInputSaturationKey)
        colorFilter?.setValue(z, forKey: kCIInputContrastKey)
        
        if let ciImage : CIImage = colorFilter?.outputImage {
                        
            let ciContext = CIContext.init()
            
            var extent : CGRect = .zero

            extent = ciImage.extent
            
            let cgImage = ciContext.createCGImage(ciImage, from: extent)
            
            let image = UIImage.init(cgImage: cgImage!)
            
            self.imageView.image = image
        }
    }

    
    func intoImage() {
        
        let controller = PSUserPhotosViewController(maxSelect: 1, selectAssets: nil, images: nil)
        
        self.present(controller, animated: true, completion: nil)
        
    }
}
