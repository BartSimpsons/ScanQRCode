//
//  QRCode.swift
//  SsQRCode
//
//  Created by simpsons on 16/9/22.
//  Copyright © 2016年 simpsons. All rights reserved.
//

import UIKit
import AVFoundation

class QRCode: UIViewController,AVCaptureMetadataOutputObjectsDelegate{

    private var scanRectView:UIView!
    
    private var device:AVCaptureDevice!
    private var input:AVCaptureDeviceInput!
    private var output:AVCaptureMetadataOutput!
    
    private var session:AVCaptureSession!
    private var preview:AVCaptureVideoPreviewLayer!
    private let windowSize:CGSize = UIScreen.main.bounds.size;
    
    private let qrCodeView = SsQRCodeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showQRCode()
        
    }
    
    func showQRCode(){
        
        self.device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            
            self.input = try AVCaptureDeviceInput(device: device)
            
            self.output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            self.session = AVCaptureSession()
            
            if UIScreen.main.bounds.size.height<500 {
                self.session.sessionPreset = AVCaptureSessionPreset640x480
            }else{
                self.session.sessionPreset = AVCaptureSessionPresetHigh
            }
            
            if self.session.canAddInput(self.input){
                
                self.session.addInput(self.input)
                
            }
            
            if self.session.canAddOutput(self.output){
                
                self.session.addOutput(self.output)
                
            }
            
            
            self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            //计算中间可探测区域
            let scanSize:CGSize = CGSize.init(width: windowSize.width*1/2, height: windowSize.width*1/2)
            
            
            let scanRect:CGRect = CGRect(x: (windowSize.width-scanSize.width)/2, y: (windowSize.height - 94 - scanSize.height)/2, width: scanSize.width, height: scanSize.height)
            
            
            self.preview = AVCaptureVideoPreviewLayer(session:self.session)
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.preview.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(self.preview, at:0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: {[weak self] (noti) in

                self?.output.rectOfInterest = (self?.preview.metadataOutputRectOfInterest(for: scanRect))!
                
                })
            
            qrCodeView.frame = self.view.frame
            qrCodeView.backgroundColor = UIColor.clear
            self.view.addSubview(qrCodeView)
            
            //开始捕获
            self.session.startRunning()
            
        }catch _ as NSError{
            //打印错误消息
            self.ShowMyAlertController("提示", info: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机")
            return
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //继续扫描
//        if self.cameraPermissions() {
//            
//            qrCodeView.startAnimation()
//            self.session.startRunning()
//            
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        if self.cameraPermissions() {
            
            qrCodeView.stopAnimation()
            
        }
    }
    
    func cameraPermissions() -> Bool{
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
        
    }

    //提示框
    func ShowMyAlertController(_ title:String,info:String){
        
        let alert = UIAlertController(title: title, message: info, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "确定", style: .default) { (action:UIAlertAction) in
            
            if self.cameraPermissions() {
                
                self.qrCodeView.startAnimation()
                self.session.startRunning()
                
            }
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }

    //摄像头捕获
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            if stringValue != nil{
                self.session.stopRunning()
            }
        }
        self.session.stopRunning()
        self.qrCodeView.stopAnimation()
        self.ShowMyAlertController("二维码网址", info: stringValue!)
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

