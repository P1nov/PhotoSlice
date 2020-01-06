//
//  PSCameraView.swift
//  PhotoSlice
//
//  Created by 雷永麟 on 2020/1/6.
//  Copyright © 2020 leiyonglin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@objc protocol PSCameraDelegate {
    
    @objc optional
    func didStartCamera(view cameraView : PSCameraView, with error : Error)
    
    @objc optional
    func didChangedDevice(view cameraView : PSCameraView, with error : Error)
    
    @objc optional
    func didCameraShot(with error : Error, cameraView : PSCameraView)
    
    func cameraShot(with image : UIImage, cameraView : PSCameraView)
}

class PSCameraView: UIView {
    
    lazy var shotButton : UIButton = {
       
        let button = UIButton()
        button.setImage(UIImage(named: "camera_shot"), for: .normal)
        button.addTarget(self, action: #selector(cameraShot), for: .touchUpInside)
        
        return button
    }()
    
    private var videoDimension : CMVideoDimensions?
    private var currentTime : CMTime?
    private var outputImage : UIImage?
    
    private var ciContext : CIContext = CIContext.init()
    
    private var filter : CIFilter?
    
    weak var cameraDelegate : PSCameraDelegate?
    
    lazy var session : AVCaptureSession? = {
        
        let session = AVCaptureSession.init()
        
        if session.canSetSessionPreset(.photo) {
            
            session.sessionPreset = .photo
        }
        
        do {
            
            if session.canAddInput(self.cameraDeviceInput!) {
                
                session.addInput(self.cameraDeviceInput!)
            }
            
            if session.canAddOutput(self.videoDataOutput!) {
                
                session.addOutput(self.videoDataOutput!)
            }
        }
        
        return session
    }()
    
    private lazy var stillImageOutput : AVCaptureStillImageOutput = {
       
        let imageOutput = AVCaptureStillImageOutput.init()
        
        imageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        
        return imageOutput
    }()
    
    private lazy var previewLayer : AVCaptureVideoPreviewLayer = {
       
        let layer = AVCaptureVideoPreviewLayer.init(session: self.session!)
        layer.frame = self.frame
        layer.videoGravity = .resizeAspectFill
        
        return layer
        
    }()
    
    private lazy var queue : DispatchQueue = {
        
        let queue = DispatchQueue.init(label: "cameraQueue")
        
        return queue
        
    }()
    
    private lazy var device : AVCaptureDevice? = {
       
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        return device
    }()
    
    private lazy var cameraDeviceInput : AVCaptureDeviceInput? = {
        
        do {
            
            let input = try AVCaptureDeviceInput.init(device: self.device!)
            
            return input
        }catch let error {
            
            self.cameraDelegate?.didStartCamera?(view: self, with: error)
            
            return nil
        }
    }()
    
    private lazy var videoDataOutput : AVCaptureVideoDataOutput? = {
       
        let output = AVCaptureVideoDataOutput.init()
        
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: self.queue)
        
        return output
        
    }()
    
    private lazy var audioDataOutput : AVCaptureAudioDataOutput = {
       
        let output = AVCaptureAudioDataOutput.init()
        
        output.setSampleBufferDelegate(self, queue: self.queue)
        
        return output
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.session?.startRunning()
        
        self.layer.addSublayer(self.previewLayer)
        
        self.addSubview(self.shotButton)
        
        shotButton.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Scale(50))
            make.height.width.equalTo(Scale(50))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        self.session?.stopRunning()
    }
    
}

extension PSCameraView : AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        autoreleasepool {
            
            if output == audioDataOutput {
                
                
            }
            
            if output == videoDataOutput {
                
                self.imageFromBuffer(sampleBuffer: sampleBuffer)
            }
        }
    }
    
    private func imageFromBuffer( sampleBuffer : CMSampleBuffer) {
        
        let imageBuffer : CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        
        videoDimension = CMVideoFormatDescriptionGetDimensions(formatDescription!)
        currentTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
        
        var result = CIImage.init(cvImageBuffer: imageBuffer, options: nil)
        
        if let currentFilter = filter {
            
            currentFilter.setValue(result, forKey: kCIInputImageKey)
            
            result = currentFilter.outputImage ?? result
        }
        
        result = result.transformed(by: CGAffineTransform.init(rotationAngle: -.pi / 2))
        
        let cgImage = ciContext.createCGImage(result, from: result.extent)
        
        outputImage = UIImage.init(cgImage: cgImage!)
        
        DispatchQueue.main.async {
            
            self.previewLayer.contents = cgImage
        }
        
    }
}

@objc
private extension PSCameraView {
    
    func set(flashMode mode : AVCaptureDevice.FlashMode) {
        
        changeDevice { (captureDevice) in
            
            if captureDevice.isFlashModeSupported(AVCaptureDevice.FlashMode.off) {
                
                captureDevice.flashMode = .on
            }else if captureDevice.isFlashModeSupported(.on) {
                
                captureDevice.flashMode = .off
            }
        }
    }
    
    func changeDevice(completion : (_ captureDevice : AVCaptureDevice) -> Void) {
        
        let captureDevice = self.cameraDeviceInput?.device
        
        do {
            
            if let _ = try captureDevice?.lockForConfiguration() {
                
                completion(captureDevice!)
                
                captureDevice?.unlockForConfiguration()
            }else {
                
                
            }
        }catch let error {
            
            self.cameraDelegate?.didChangedDevice?(view: self, with: error)
        }
        
    }
    
    func cameraShot() {
        
        self.session!.stopRunning()
        
        saveImageWithImage(image: outputImage!)
        
        self.session?.startRunning()
    }
    
    func saveImageWithImage(image : UIImage) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            if status != .authorized {
                
                PNProgressHUD.present(with: "保存失败,App无权限访问相册", presentType: .popup, font: UIFont.systemFont(ofSize: 14.0, weight: .medium), backgroundColor: UIColor(rgb: 0xFF4B32), textColor: .white, in: nil)
            }else {
                
                self.cameraDelegate?.cameraShot(with: self.outputImage!, cameraView: self)
            }
        }
    }
}
