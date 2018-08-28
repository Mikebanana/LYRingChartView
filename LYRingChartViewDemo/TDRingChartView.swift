//
//  TDRingChartView.swift
//  Tudou
//
//  Created by discover on 2017/8/21.
//  Copyright © 2017年 Tudou. All rights reserved.
//

import UIKit

class TDRingChartView: UIView {
    
    var percentArr:[Double]?{
        didSet{
            for ele in Layer.sublayers!{
                ele.removeFromSuperlayer()
            }
            Layer.removeFromSuperlayer()
            for ele in self.zheLineArr{
                ele.removeFromSuperlayer()
            }
            self.zheLineArr.removeAll()
            for ele in self.laberArr{
                ele.removeFromSuperview()
            }
            self.laberArr.removeAll()
            self.tempPercent = 0
            self.timePercent = 0
            drawLayer()
            
        }
    }     //百分比
    fileprivate   var colorArr:[UIColor]?       //颜色
    fileprivate   var durtion:Double?           //时间
    fileprivate  var tempPercent:Double = 0
    fileprivate  var timePercent:Double = 0
    fileprivate  let ringWidth:CGFloat = 20
    fileprivate  let  labelWidth:CGFloat = 20
    
    var titleArr :[String]! {
        didSet{
            drawLayer()
        }
    }
    let zheLineLength:CGFloat = 90
    let zheLineHeadLength:CGFloat = 20
    var zheLineArr = [CAShapeLayer]()
    var laberArr = [UILabel]()
    lazy var  width:CGFloat = {
        return self.frame.width
    }()
    lazy var  height:CGFloat = {
        return self.frame.height
    }()

    init(frame: CGRect,percentArr:[Double],colorArr:[UIColor],durtion:Double) {
        super.init(frame: frame)
        self.percentArr = percentArr
        self.colorArr = colorArr
        self.durtion = durtion
        self.backgroundColor = UIColor.white;
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let Layer = CAShapeLayer.init()
    
    //MARK:重新绘制视图
    
    func drawLayer() {
        
        Layer.frame = self.bounds
        Layer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(Layer)
        
        for (index,percent) in self.percentArr!.enumerated(){
            
            let circleLayer = CAShapeLayer.init()
            circleLayer.lineWidth = ringWidth/2.0  //环形宽度
            circleLayer.strokeColor = colorArr?[index].cgColor//颜色
            circleLayer.fillColor = UIColor.clear.cgColor
            
            let startAngle = CGFloat(self.tempPercent*Double.pi*2+Double.pi)
            let endAngle = CGFloat(Double.pi*2*(percent+self.tempPercent)+Double.pi)
            let start = CGFloat(self.tempPercent*180*2+180)
            let end = CGFloat(180*2*(percent+self.tempPercent)+180)
            
            let path = UIBezierPath.init(arcCenter: CGPoint.init(x: self.width/2.0, y: self.height/2.0), radius: self.width/2.0-ringWidth/4.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            circleLayer.path = path.cgPath
            circleLayer.strokeEnd = 0
            self.backgroundColor = UIColor.white
            var  angel =   start + (end -  start)/2
            
            if angel > 180{
                angel = 180 - (angel - 180)
            }
            
            let point =  alcCircleCoordinateWithCenter(angle: angel)
            
            addLine(point: point,angle:angel,index:index)
            
            self.Layer.addSublayer(circleLayer)
            
            
            self.tempPercent = percent+self.tempPercent;
            
        }
        if self.Layer.sublayers?.count == self.percentArr?.count{
            
            self.beginAnimation()
            
        }
        
        
        
    }
    
    func addLine(point:CGPoint,angle:CGFloat,index:Int){
        let shape =  CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: point)
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        let str = String.init(format: "%.2f%%", percentArr![index]*100)
        label.text = titleArr[index] + str
        label.textAlignment = .center
        self.addSubview(label)
        if -90<angle&&angle<0{
            
            path.addLine(to: CGPoint.init(x: point.x+zheLineHeadLength, y: point.y+zheLineHeadLength))
            path.addLine(to: CGPoint.init(x: point.x+zheLineHeadLength+zheLineLength, y: point.y+zheLineHeadLength))
            label.frame = CGRect(x: point.x+zheLineHeadLength, y: point.y+zheLineHeadLength - labelWidth, width: zheLineLength, height: labelWidth)
            
        } else if -180<angle&&angle < -90{
            path.addLine(to: CGPoint.init(x: point.x-zheLineHeadLength, y: point.y+zheLineHeadLength))
            path.addLine(to: CGPoint.init(x: point.x-zheLineHeadLength-zheLineLength, y: point.y+zheLineHeadLength))
            label.frame = CGRect(x: point.x-zheLineHeadLength-zheLineLength, y: point.y+zheLineHeadLength - labelWidth, width: zheLineLength, height: labelWidth)
            
            
        }else if 90<angle&&angle < 180{
            path.addLine(to: CGPoint.init(x: point.x-zheLineHeadLength, y: point.y-zheLineHeadLength))
            path.addLine(to: CGPoint.init(x: point.x-zheLineHeadLength-zheLineLength, y: point.y-zheLineHeadLength))
            label.frame = CGRect(x: point.x-zheLineHeadLength-zheLineLength, y: point.y-zheLineHeadLength , width: zheLineLength, height: labelWidth)
            
            
        }else{
            path.addLine(to: CGPoint.init(x: point.x+zheLineHeadLength, y: point.y-zheLineHeadLength))
            path.addLine(to: CGPoint.init(x: point.x+zheLineHeadLength+zheLineLength, y: point.y-zheLineHeadLength))
            label.frame = CGRect(x: point.x+zheLineHeadLength, y: point.y-zheLineHeadLength , width: zheLineLength, height: labelWidth)
            
        }
        
        
        shape.path = path.cgPath
        shape.strokeColor = colorArr![index].cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 1
        shape.isHidden = true
        label.isHidden = true
        zheLineArr.append(shape)
        laberArr.append(label)
        self.layer.addSublayer(shape)
        
    }
    
    func alcCircleCoordinateWithCenter(angle:CGFloat)->CGPoint{
        let radiu = self.width/2.0-ringWidth/4.0
        let x2 = radiu * CGFloat(cosf(Float(angle*CGFloat.pi/180)))
        let y2 = radiu * CGFloat(sinf(Float(angle*CGFloat.pi/180)))
        return CGPoint(x:self.width/2.0+x2, y:self.width/2.0-y2);
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let radiy = self.width/2.0-ringWidth/4.0
        let touchPoint = touches.first?.location(in: self)
        
        var   θ  = atan2((touchPoint!.y-radiy),(touchPoint!.x-radiy))
        
        θ += CGFloat.pi
        var p:CGFloat = 0
        var q:CGFloat = 0
        for (index,per) in percentArr!.enumerated(){
            let percent = CGFloat(per)
            p += percent
            if θ < (p*2*CGFloat.pi)&&θ > (q*2*CGFloat.pi){
                changeLineWidth(index: index)
                return
            }
            q = percent
        }
        
    }
    func changeLineWidth(index:Int){
        for (i,shape) in zheLineArr.enumerated(){
            if index == i{
                
                shape.isHidden = false
            }else{
                
                shape.isHidden = true
            }
        }
        for (i,shape) in laberArr.enumerated(){
            if index == i{
                
                shape.isHidden = false
            }else{
                
                shape.isHidden = true
            }
        }
        
        for (i,yer) in Layer.sublayers!.enumerated(){
            let shape =  yer as! CAShapeLayer
            if index == i{
                
                shape.lineWidth = 15
            }else{
                
                shape.lineWidth = 10
                
            }
        }
        
    }
    
    
    
    
    
    func beginAnimation(){
        
        for (index,circleLayer) in (self.Layer.sublayers?.enumerated())!{
            let circle = circleLayer as! CAShapeLayer
            circle.strokeEnd = 0
            let time: TimeInterval = self.durtion!*self.timePercent
            let percent = self.percentArr?[index]
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                
                let animation = CABasicAnimation.init(keyPath: "strokeEnd")
                
                animation.duration = self.durtion!*percent!
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                animation.beginTime = CACurrentMediaTime()
                animation.fromValue = NSNumber.init(value: 0)
                animation.toValue = NSNumber.init(value: 1)
                circle.add(animation, forKey: "animation"+"\(index)")
                
                
            }
            self.timePercent = percent! + self.timePercent
            
        }
    }
    
    
    
    
    
}
