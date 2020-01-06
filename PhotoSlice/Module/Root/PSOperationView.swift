//
//  PSOperationView.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2019/12/25.
//  Copyright © 2019 leiyonglin. All rights reserved.
//

import UIKit

protocol PSOperationViewDelegate : NSObjectProtocol {
    
    func longImageSlice(operationView : PSOperationView)
    
    func cameraClick(operationView : PSOperationView)
}

class PSOperationView: UIView {
    
    weak var operationViewDelegate : PSOperationViewDelegate?
    
    lazy var longImageSliceButton: UIButton = {
        
        let button = UIButton()
        button.frame.size = .init(width: Scale(40), height: Scale(40))
        button.frame.origin = .init(x: self.center.x - Scale(20), y: self.frame.height + Scale(10))
        button.setImage(UIImage(named: "add_new"), for: .normal)
        
        button.addTarget(self, action: #selector(longImageSliceClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var gridImageSliceButton: UIButton = {
        
        let button = UIButton()
        button.frame.size = .init(width: Scale(40), height: Scale(40))
        button.frame.origin = .init(x: self.center.x - Scale(20), y: self.frame.height + Scale(10))
        button.setImage(UIImage(named: "add_new"), for: .normal)
        
        button.addTarget(self, action: #selector(cameraClick), for: .touchUpInside)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        
        
        
    }
    
    func present(at superView : UIView) {
        
        for subView in superView.subviews {
            
            if subView is PSOperationView {
                
                dismiss()
                
                return
            }
        }
        
        superView.addSubview(self)
        
        addSubview(longImageSliceButton)
        addSubview(gridImageSliceButton)
        
        self.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            
            self.alpha = 1.0
            
            self.longImageSliceButton.frame.origin = .init(x: self.center.x - Scale(50) - self.longImageSliceButton.currentImage!.size.width, y: self.frame.height - Scale(100))
            self.gridImageSliceButton.frame.origin = .init(x: self.center.x + Scale(50), y: self.frame.height - Scale(100))
            
        }) { (success) in
            
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dismiss()
    }
    
    func dismiss() {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 7, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            
            self.alpha = 0.0
            
            self.longImageSliceButton.frame.origin = .init(x: self.center.x - Scale(20), y: self.frame.height + Scale(10))
            self.gridImageSliceButton.frame.origin = .init(x: self.center.x - Scale(20), y: self.frame.height + Scale(10))
        }) { (success) in
            
            self.longImageSliceButton.removeFromSuperview()
            self.gridImageSliceButton.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func longImageSliceClick() {
        
        self.operationViewDelegate?.longImageSlice(operationView: self)
    }
    
    @objc private func cameraClick() {
        
        self.operationViewDelegate?.cameraClick(operationView: self)
    }
    
}
