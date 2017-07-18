//
//  BezierPathButton.swift
//  monitor
//
//  Created by hengchengfei on 15/9/13.
//  Copyright © 2015年 chengfeisoft. All rights reserved.
//

import UIKit

@IBDesignable  class BezierTextField: UITextField {
    
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0
    
    /**
     设置哪个角度需要切边
     0:topLeft
     1:topRight
     2:bottomLeft
     3:bottomRight
     4:topLeft + bottomLeft
     5:topRight + bottomRight
     **/
    @IBInspectable var roundingCorners:Int = 0{
        didSet{
            
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            
            layer.mask = maskLayer
        }
    }
    
}
