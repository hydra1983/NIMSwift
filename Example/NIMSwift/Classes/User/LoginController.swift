//
//  LoginController.swift
//  NIMSwift
//
//  Created by 衡成飞 on 4/27/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import CFProgressHUD
import CFExtension
import PromiseKit

class LoginController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userIdTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didClickLogin(){
        hideKeyboard()
        guard let userName = userIdTextField.text?.trimSpacesBeforeAndAfter(),userName.characters.count > 0   else {
            self.view.showHUDMsg(msg: "请输入账号")
            return
        }
        
        guard let password = passwordTextField.text?.trimSpacesBeforeAndAfter(),password.characters.count > 0   else {
            self.view.showHUDMsg(msg: "请输入密码")
            return
        }
        
        self.view.showHUDProgress()
        
        NIMSDK.shared().loginManager.login(userName, token: password, completion: { error in
            self.view.hiddenAllMessage()
            
            if error == nil {
                let data = LoginData()
                data.nimAccount = userName
                data.nimToken = password
                let info = NIMKit.shared().info(byUser: userName, option: nil)
                data.nimNick = info?.showName
                
                LoginManager.shareInstance.setCurrentAccount(data: data)
                
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }else{
                print(error!)
                self.view.showHUDMsg(msg: "登录失败 \(error!.code)")
            }
        })
        
    }
    
    func hideKeyboard() {
        userIdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
