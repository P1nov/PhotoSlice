//
//  PNProgressHUD.swift
//  UITestDemo
//
//  Created by ma c on 2019/12/22.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit

class PNProgressHUDView : UIView {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: self.frame.origin.y - Scale(20), width: self.frame.width - Scale(50), height: 0.0))
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = Scale(8)
        
        return label
    }()
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.addSubview(titleLabel)
        
        titleLabel.center = self.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PNProgressLoadingViewCustom: UIView {
    
    private lazy var mainView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.backgroundColor = .clear
        view.layer.borderColor = RGB(R: 180, G: 180, B: 180)?.cgColor
        view.layer.borderWidth = 5
        return view
    }()
    
    private var count: Int = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.mainView)
        
        let bezie:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: 17.5, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.black.cgColor
//        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = bezie.cgPath
        shapeLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        setGradualChangingColor(targetLayer: shapeLayer, color: RGB(R: 255, G: 0, B: 42)!, toColor: UIColor.white)
        self.layer.addSublayer(shapeLayer)
        
        self.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func start() {
        let rotation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.repeatCount = MAXFLOAT
        rotation.duration = 1
        rotation.isRemovedOnCompletion = false
        self.layer.add(rotation, forKey: nil)
    }
    
    func setGradualChangingColor(targetLayer:CAShapeLayer, color:UIColor, toColor:UIColor){
        let gradLayer:CAGradientLayer = CAGradientLayer()
        gradLayer.frame = targetLayer.bounds
        gradLayer.colors = [color.cgColor,toColor.cgColor]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        gradLayer.locations = [0,1]
        self.layer.addSublayer(gradLayer)
    }
    
}

class PNProgressLoadingView : UIView {
    
    /// 背景view
    private lazy var bacView: UIView = {
        let view = UIView(frame: CGRect(x: kScreenWidth/3, y: (kScreenHeight - 60)/2, width: kScreenWidth/3, height: 60))
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        return view
    }()
    
    /// 透明效果
    private lazy var visual: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let vis = UIVisualEffectView(effect: blur)
        vis.frame = CGRect(x: 0, y: 0, width: kScreenWidth/3, height: 60)
        vis.backgroundColor = .white
        vis.alpha = 0.8
        vis.layer.cornerRadius = 5
        vis.layer.masksToBounds = true
        return vis
    }()
    
    /// 自定义菊花
    private lazy var custom: LSDIndicatorCustom = {
        let view = LSDIndicatorCustom(frame: CGRect(x: (kScreenWidth/3 - 40)/2, y: 10, width: 90, height: 40))
        view.center = self.center
        return view
    }()
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.backgroundColor = .clear
        self.addSubview(self.bacView)
        self.bacView.addSubview(self.visual)
        self.bacView.addSubview(self.custom)
    }
    
    /// 把我show出来
    public func showMe(_ view: UIView) {
        self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        view.addSubview(self)
        self.presentAnimation()
    }
    
    /// window上弹出来
    public func showMeInWindow() {
        self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.presentAnimation()
    }
    
    /// 变消失
    public func dismiss() {
        self.dissAnimation()
    }
    
    /// 弹出视图
    private func presentAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    /// 消失了
    private func dissAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        }) { _ in
            self.removeFromSuperview()
        }
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LSDMidIndicatorView deinit")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
}

class PNProgressHUD: NSObject {
    
    var loadingView : PNProgressLoadingView?
    
    enum PresentType {
        case popup
        case fromTop
        case fromBottom
    }
    
    enum WarningType {
        
        case error
        case warning
        case success
        case `default`
    }
    
    /**
     - Parameters:
     - title: 提示内容（不能为空）
     - presentType: 弹窗方式
     - font: 字体（可为空，为空使用默认字体）
     - backgroundColor: 弹窗提示的背景色（可为空，默认为白色）
     - textColor: 字色（可为空，默认为黑色）
     - superView: 父视图（为空则是window上显示）
     */
    class func present(with title : NSString, presentType : PresentType, font : UIFont?, backgroundColor : UIColor?, textColor : UIColor?, in superView : UIView?) {
        
        let hudView : PNProgressHUDView = PNProgressHUDView()
        if backgroundColor != nil {
            
            hudView.titleLabel.backgroundColor = backgroundColor!
        }
        
        if textColor != nil {
            
            hudView.titleLabel.textColor = textColor
        }
        
        if font != nil {
            
            hudView.titleLabel.font = font!
        }
        
        let height = title.boundingRect(with: .init(width: hudView.bounds.width, height: 0.0), options: NSStringDrawingOptions.Element(rawValue: NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue), attributes: [NSAttributedString.Key.font : font != nil ? font as Any : UIFont.systemFont(ofSize: 14.0)], context: nil).size.height
        
        hudView.titleLabel.text = String(title)
        hudView.titleLabel.frame.size.height = height + 40
        
        presentAnimation(view: hudView, presentType: presentType, superView: superView)
        
    }
    
    class func presentAnimation(view : PNProgressHUDView, presentType : PresentType, superView : UIView?) {
        
        var newSuperView : UIView?
        
        if superView == nil {
            
            var keyWindow : UIWindow?
            
            for window in UIApplication.shared.windows {
                if (window.isKeyWindow) {
                    // you have the key window
                    
                    keyWindow = window
                    
                    break;
                }
            }
            
            guard let currentWindow = keyWindow else {
                
                return
            }
            
            currentWindow.addSubview(view)
            
            newSuperView = currentWindow
            
        }else {
            
            superView?.addSubview(view)
            newSuperView = superView
        }
        
        
        switch presentType {
        case .popup:
            
            view.titleLabel.center = view.center
            
            view.titleLabel.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.1, animations: {
                
                view.titleLabel.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }) { (completed) in
                
                UIView.animate(withDuration: 0.1, delay: 1, options: .curveEaseInOut, animations: {
                    
                    view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }) { (completed) in
                    
                    view.removeFromSuperview()
                }
            }
            break
        case .fromTop:
            
            view.titleLabel.center = CGPoint(x: newSuperView!.bounds.width / 2.0, y: newSuperView!.bounds.origin.y - view.titleLabel.bounds.height / 2.0)
            
            UIView.animate(withDuration: 0.1, animations: {
                
                view.titleLabel.center = CGPoint(x: newSuperView!.bounds.width / 2.0, y: newSuperView!.bounds.origin.y + Scale(10) + view.titleLabel.frame.height)
            }) { (completed) in
                
                UIView.animate(withDuration: 0.1, delay: 1, options: .curveEaseInOut, animations: {
                    
                    view.titleLabel.center = CGPoint(x: newSuperView!.bounds.width / 2.0, y: newSuperView!.bounds.origin.y - view.titleLabel.bounds.height / 2.0)
                }) { (completed) in
                    
                    view.removeFromSuperview()
                }
            }
            break
        default:
            break
        }
        
        
    }
    
    class func loading(at superView : UIView?) {
        
        var newSuperView : UIView?
        
        var loadingView : PNProgressLoadingView?
        
        if superView == nil {
            
            var keyWindow : UIWindow?
            
            for window in UIApplication.shared.windows {
                if (window.isKeyWindow) {
                    // you have the key window
                    
                    keyWindow = window
                    
                    break;
                }
            }
            
            guard let currentWindow = keyWindow else {
                
                return
            }
            
            loadingView = PNProgressLoadingView()
            loadingView!.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            currentWindow.addSubview(loadingView!)
            
            newSuperView = currentWindow
            
        }else {
            
            loadingView = PNProgressLoadingView()
            loadingView!.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            
            superView?.addSubview(loadingView!)
            
            newSuperView = superView
        }
        
        loadingView?.showMe(newSuperView!)
        
    }
    
    class func hideLoading(from superView : UIView?) {
        
        if superView == nil {
            
            var keyWindow : UIWindow?
            
            for window in UIApplication.shared.windows {
                if (window.isKeyWindow) {
                    // you have the key window
                    
                    keyWindow = window
                    
                    break;
                }
            }
            
            guard let currentWindow = keyWindow else {
                
                return
            }
            
            var isHided : Bool = false
            
            for subView in currentWindow.subviews {
                
                if isHided {
                    
                    break
                }
                
                if subView.isKind(of: PNProgressLoadingView.self) {
                    
                    (subView as! PNProgressLoadingView).dismiss()
                    
                    isHided = true
                }
            }
            
        }else {
            
            var isHided : Bool = false
            
            for subView in superView!.subviews {
                
                if isHided {
                    
                    break
                }
                
                if subView.isKind(of: PNProgressLoadingView.self) {
                    
                    (subView as! PNProgressLoadingView).dismiss()
                    
                    isHided = true
                }
            }
        }
    }

}
