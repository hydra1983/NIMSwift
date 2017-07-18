//
//  IMSpellingUtil.swift
//  NIMSwift
//
//  Created by 衡成飞 on 6/12/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMSpellingUtil {
    public static let shareInstance:IMSpellingUtil = {
        let instance = IMSpellingUtil()
        return instance
    }()
    
    
    /**
       取得分组的首字母
    **/
    func groupTitle(_ txt:String) -> String {
        let title = NIMSpellingCenter.shared().firstLetter(txt).capitalized
        if title >= "A" && title <= "Z"{
            return title
        }else{
            return "#"
        }
    }
    
}
