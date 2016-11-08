//
//  SsQRCodeView.swift
//  QRCodeDemo
//
//  Created by simpsons on 16/9/21.
//  Copyright © 2016年 simpsons. All rights reserved.
//

import UIKit

class SsQRCodeView: UIView {

    
    private let SsLineAnimateDuration:TimeInterval = 0.02
    private var imgLine:UIImageView!
    private var labelDesc:UILabel!
    private var lineOriginY:CGFloat!
    private var rectY:CGFloat!
    private var timer:Timer!
    private let scanSize:CGSize = CGSize.init(width: UIScreen.main.bounds.size.width*1/2, height: UIScreen.main.bounds.size.width*1/2)
    
    private let SizeH = UIScreen.main.bounds.size.height-94
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if (imgLine == nil) {
            
            rectY = (SizeH-scanSize.height)/2
            self.addLine()
            timer = Timer(timeInterval: SsLineAnimateDuration, target: self, selector: #selector(lineDrop), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            
        }
        
        if labelDesc == nil{
            self.addDescView()
        }
        
    }
    
    func addDescView(){
        
        labelDesc = UILabel()
        labelDesc.frame = CGRect(x: 0, y: (SizeH + scanSize.height)/2 + 10, width: self.frame.width, height: 30)
        labelDesc.text = "将二维码放入框内，即可自动扫描"
        labelDesc.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        labelDesc.textAlignment = NSTextAlignment.center
        labelDesc.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(labelDesc)
        
    }
    
    func addLine(){
        
        imgLine = UIImageView(frame: CGRect.init(x: 0, y: 0, width: scanSize.width, height: 2))
        imgLine.image = UIImage(named: "Line")
        imgLine.center = CGPoint.init(x: self.frame.width/2, y: rectY + 2)
        
        lineOriginY = imgLine.frame.origin.y
        self.addSubview(imgLine)
        
    }
    
    func lineDrop(){
        
        UIView .animate(withDuration: SsLineAnimateDuration, animations: { 
            
            var rect = self.imgLine.frame
            rect.origin.y = self.lineOriginY
            self.imgLine.frame = rect
            
            
        }) { (complite:Bool) in
            
            let maxBorder = self.rectY + self.scanSize.height - 4
            if (self.lineOriginY > maxBorder){
                self.lineOriginY = self.rectY + 4
            }
            
            self.lineOriginY = self.lineOriginY + 1
        }
        
    }
    
    func stopAnimation(){
        
        timer.invalidate()
        timer = nil
        
    }
    
    func startAnimation(){
        
        timer = Timer(timeInterval: SsLineAnimateDuration, target: self, selector: #selector(lineDrop), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let screenDrawRect = self.frame
        
        
        
        let clearDrawRect = CGRect.init(x: (UIScreen.main.bounds.size.width-scanSize.width)/2, y: (SizeH-scanSize.height)/2, width: scanSize.width, height: scanSize.height)
        
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        self.addScreenFillRect(ctx: ctx, rect: screenDrawRect)
        self.addCenterClearRect(ctx: ctx, rect: clearDrawRect)
        self.addCornerGreenLine(ctx: ctx, rect: clearDrawRect)
        
    }
    
    func addScreenFillRect(ctx:CGContext, rect:CGRect){
        
        ctx.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        ctx.fill(rect)
        
    }
    
    func addCenterClearRect(ctx:CGContext, rect:CGRect){
        
        ctx.clear(rect)
        
    }
    
    func addCornerGreenLine(ctx:CGContext, rect:CGRect){
        
        let lineWidth:CGFloat = 4
        let lineHeight:CGFloat = 18
        //四个角
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(red: 83/255.0, green: 239/255.0, blue: 111/255.0, alpha: 1) //绿色
        
        
        //左上角  顺序 ：竖 横
        ctx.move(to: CGPoint.init(x: rect.origin.x + lineWidth/2, y: rect.origin.y))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + lineWidth/2, y: rect.origin.y + lineHeight))
        ctx.strokePath()
        
        ctx.move(to: CGPoint.init(x: rect.origin.x, y: rect.origin.y + lineWidth/2))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + lineHeight, y: rect.origin.y + lineWidth/2))
        ctx.strokePath()


        
        //右上角
        ctx.move(to: CGPoint.init(x: rect.origin.x + rect.size.height - lineWidth/2, y: rect.origin.y))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + rect.size.height - lineWidth/2, y: rect.origin.y + lineHeight))
        ctx.strokePath()

        ctx.move(to: CGPoint.init(x: rect.origin.x + rect.size.height, y: rect.origin.y + lineWidth/2))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + rect.size.height - lineHeight, y: rect.origin.y + lineWidth/2))
        ctx.strokePath()

        
        //左下角
        ctx.move(to: CGPoint.init(x: rect.origin.x + lineWidth/2, y: rect.origin.y + rect.size.height))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + lineWidth/2, y: rect.origin.y + rect.size.height - lineHeight))
        ctx.strokePath()
        
        ctx.move(to: CGPoint.init(x: rect.origin.x, y: rect.origin.y + rect.size.height -  lineWidth/2))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + lineHeight, y: rect.origin.y + rect.size.height - lineWidth/2))
        ctx.strokePath()
        
        
        //右下角
        ctx.move(to: CGPoint.init(x: rect.origin.x + rect.size.width - lineWidth/2, y: rect.origin.y + rect.size.height))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + rect.size.width - lineWidth/2, y: rect.origin.y + rect.size.height - lineHeight))
        ctx.strokePath()
        
        ctx.move(to: CGPoint.init(x: rect.origin.x + rect.size.width, y:rect.origin.y + rect.size.height))
        ctx.addLine(to: CGPoint.init(x: rect.origin.x + rect.size.width - lineHeight, y: rect.origin.y + rect.size.height - lineWidth/2))
        ctx.strokePath()
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
