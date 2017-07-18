//
//  Keys.swift
//  NIMSwift
//
//  Created by 衡成飞 on 5/10/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

struct Constants {
    
    //Development
    static let kNIMKey = "bb681f3f1472cef7ab8d767574ab4787" //云信
    static let kNIMCerName = "NIMSwiftDev"                     //云信
    static let kQNKey = "Tzk2Oq7KrzVzitGtkJYCxvz5q763uxf0NZGtp6zg" //七牛


    //主色调
    static let kColorIconDefault = 0x1296db
    static let kColorIconyChanged = 0x1296db
    static let kColorTabBackground = 0xFFFFFF
    
    static let kScreenHeight = UIScreen.main.bounds.size.height
    static let kScreenWidth = UIScreen.main.bounds.size.width
    
    //尺寸
    static let kIPHONE4 = UIScreen.main.bounds.size.equalTo(CGSize(width: 320, height: 480))
    static let kIPHONE5 = UIScreen.main.bounds.size.equalTo(CGSize(width: 320, height: 568))
    static let kIPHONE6 = UIScreen.main.bounds.size.equalTo(CGSize(width: 375, height: 667))
    static let kIPHONE6PLUS = UIScreen.main.bounds.size.equalTo(CGSize(width: 414, height: 736))
    static let kIPAD = UIDevice.current.userInterfaceIdiom == .pad ? true : false
    
    //通知
    static let kNotificationTypeLogout = "Logout"
    static let kNotificationTypeTeamChange = "TeamChange"
    static let kNotificationTypeUserInfoChange = "UserInfoChange"
    static let kNotificationGetSelectDate = "GetSelectDate"

}
