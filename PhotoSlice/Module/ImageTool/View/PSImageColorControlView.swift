//
//  PSImageColorControlView.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/7.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit

@objc protocol PSImageColorControlDelegate {
    
    @objc optional
    func adjustImageColor(x : CGFloat, y : CGFloat, z : CGFloat, w : CGFloat)
    
    @objc optional
    func adjustImageColorControl(x : CGFloat, y : CGFloat, z : CGFloat)
}

class PSImageColorControlView: UIView {
    
    enum ControlMode {
        case clamp
        case control
    }
    
    var mode : ControlMode? = .clamp {
        
        didSet {
            
            if self.mode == .control {
                
                self.saturationSlider.minimumValue = 0.5
                
                wSlider.value = 0
                contrastSlider.value = 0
                brightnessSlider.value = 0
            }else {
                
                wSlider.value = 0
                contrastSlider.value = 0
                brightnessSlider.value = 0
            }
        }
    }
    
    var x : CGFloat = 0
    var y : CGFloat = 0.5
    var z : CGFloat = 0
    var w : CGFloat = 0
    
    weak var colorDelegate : PSImageColorControlDelegate?
    
    ///亮度
    lazy var brightnessSlider: UISlider = {
        
        let slider = UISlider.init()
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(adjustImage), for: .valueChanged)
        slider.value = 0.0
        slider.tag = 1
        slider.tintAdjustmentMode = .automatic
        
        return slider
    }()
    
    ///对比度
    lazy var contrastSlider: UISlider = {
        
        let slider = UISlider.init()
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        slider.value = 0.0
        slider.tag = 2
        slider.addTarget(self, action: #selector(adjustImage), for: .valueChanged)
        
        slider.tintAdjustmentMode = .automatic
        
        return slider
    }()
    
    ///饱和度
    lazy var saturationSlider: UISlider = {
        
        let slider = UISlider.init()
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        slider.value = 0.0
        slider.tag = 3
        slider.addTarget(self, action: #selector(adjustImage), for: .valueChanged)
        
        slider.tintAdjustmentMode = .automatic
        
        return slider
    }()
    
    lazy var wSlider: UISlider = {
        
        let slider = UISlider.init()
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(adjustImage), for: .valueChanged)
        slider.value = 0.0
        slider.tag = 4
        slider.tintAdjustmentMode = .automatic
        
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubview(brightnessSlider)
        addSubview(saturationSlider)
        addSubview(contrastSlider)
        addSubview(wSlider)
        
        brightnessSlider.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(Scale(10))
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(Scale(50))
            make.centerX.equalToSuperview()
        }
        
        saturationSlider.snp.makeConstraints { (make) in
            
            make.top.equalTo(brightnessSlider.snp_bottom).offset(Scale(10))
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(Scale(50))
            make.centerX.equalToSuperview()
        }
        
        contrastSlider.snp.makeConstraints { (make) in
            
            make.top.equalTo(saturationSlider.snp_bottom).offset(Scale(10))
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(Scale(50))
            make.centerX.equalToSuperview()
        }
        
        wSlider.snp.makeConstraints { (make) in
            
            make.top.equalTo(contrastSlider.snp_bottom).offset(Scale(10))
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(Scale(50))
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc
private extension PSImageColorControlView {
    
    func adjustImage(slider : UISlider) {
        
        if slider.tag == 1 {
            
            self.x = CGFloat(slider.value / 3)
        }else if slider.tag == 2 {
            
            self.y = CGFloat(slider.value)
        }else if slider.tag == 3{
            
            self.z = CGFloat(slider.value)
        }else {
            
            self.w = CGFloat(slider.value)
        }
        
        if mode == .clamp {
            
            self.colorDelegate?.adjustImageColor?(x: x, y: y, z: z, w: w)
        }else {
            
            if y < 0.5 {
                
                y = -2 * y
            }
            
            self.colorDelegate?.adjustImageColorControl?(x: x * 2, y: y, z: z * 4)
        }
        
        
        
    }
}
