//
//  LoginManager.swift
//  NIMSwift
//
//  Created by 衡成飞 on 4/27/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class LoginData:NSObject,NSCoding {

    fileprivate let TWNIMAccountId = "NIMAccount" //云信ID
    fileprivate let TWNIMToken = "NIMToken"       //云信token
    fileprivate let TWNIMNick = "NIMNick"       //云信昵称
    
    var nimAccount:String?
    var nimToken:String?
    var nimNick:String?
    
    override init(){}
    
    //解档
    required init(coder decoder:NSCoder){
        super.init()
        nimAccount = decoder.decodeObject(forKey: TWNIMAccountId) as? String
        nimToken = decoder.decodeObject(forKey: TWNIMToken) as? String
        nimNick = decoder.decodeObject(forKey: TWNIMNick) as? String
    }
    
    //归档
    func encode(with encoder:NSCoder){
        encoder.encode(nimAccount,forKey: TWNIMAccountId)
        encoder.encode(nimToken,forKey: TWNIMToken)
        encoder.encode(nimNick,forKey: TWNIMNick)
    }
    
    
}

class LoginManager: NSObject {
    fileprivate var path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last)! + "nimswift_account.data"
    
    public static let shareInstance:LoginManager = {
        let instance = LoginManager()
        instance.readData()
        return instance
    }()
   
    var loginData:LoginData?
    
    /** 取得账户信息 **/
    func readData() {
        let obj = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        if let o = obj as? LoginData{
            loginData = o
        }
    }
    
    /** 保存账户信息 **/
    func saveData(){
        if let acc = loginData {
            NSKeyedArchiver.archiveRootObject(acc, toFile: path)
        }
    }
    
    /** 设置当前账户信息 **/
    func setCurrentAccount(data:LoginData){
        loginData = data
        saveData()
    }
    
    /** 退出登录 **/
    func logout(){
        if let _ = loginData?.nimToken{
            loginData?.nimToken = nil
        }
        saveData()
        
        NIMSDK.shared().loginManager.logout(nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kNotificationTypeLogout), object: nil)
    }
    
    /** 是否已登录 **/
    func isLogin() -> Bool{
//        readData()
        if let d = loginData?.nimToken,d.characters.count > 0 {
            return true
        }
        return false
    }
}
