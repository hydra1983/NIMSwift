//
//  CircleButton.swift
//  eval
//
//  Created by hengchengfei on 15/9/13.
//  Copyright © 2015年 chengfeisoft. All rights reserved.
//

import UIKit

@IBDesignable  class CircleTextField: UITextField {

    @IBInspectable   var borderColor:UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable   var borderWidth:CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable   var cornerRadius:CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
}
