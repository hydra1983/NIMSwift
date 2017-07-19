//
//  AppDelegate.swift
//  NIMSwift
//
//  Created by hengchengfei@sina.com on 06/29/2017.
//  Copyright (c) 2017 hengchengfei@sina.com. All rights reserved.
//

import UIKit
import CFExtension

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        setupStyle()
        setupNIM()
        setupMainUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupMainUI), name: NSNotification.Name(rawValue: Constants.kNotificationTypeLogout), object: nil)
        
        return true
    }

    
    func setupStyle(){
        UIApplication.shared.statusBarStyle = .default
        UINavigationBar.appearance().tintColor = UIColor(netHex: 0x1296db, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(netHex: 0xFFFFFF, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(netHex: 0x1296db, alpha: 1)]
        UINavigationBar.appearance().autoresizingMask = [.flexibleWidth,.flexibleBottomMargin,.flexibleLeftMargin]
        
        UITabBar.appearance().barTintColor = UIColor(netHex:0xFFFFFF, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(netHex: 0x1296db, alpha: 1)
    }
    
    func setupNIM(){
        NIMSDK.shared().register(withAppID: Constants.kNIMKey, cerName: Constants.kNIMCerName)
        //关闭https（否则部分头像显示不出来）
        NIMSDKConfig.shared().enabledHttpsForInfo = false
        NIMSDKConfig.shared().enabledHttpsForMessage = false
        
        //print("###################" + NIMSDK.shared().currentLogFilepath())
    }
    
    func setupMainUI(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        if LoginManager.shareInstance.isLogin() {
            let data = LoginManager.shareInstance.loginData!
            NIMSDK.shared().loginManager.autoLogin(data.nimAccount!, token: data.nimToken!)
            window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }else{
            let vc = UIStoryboard.init(name: "User", bundle: nil).instantiateViewController(withIdentifier: "LoginController")
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
        }
        window?.makeKeyAndVisible()
    }
    


}

