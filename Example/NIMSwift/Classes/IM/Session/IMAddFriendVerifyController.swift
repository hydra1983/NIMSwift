//
//  IMAddFriendVerifyController.swift
//  NIMSwift
//
//  好友验证
//
//  Created by 衡成飞 on 6/8/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import CFProgressHUD

class IMAddFriendVerifyController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var verifyTextField:UITextField!
    
    var userOrTeamId:String!
    var type:Int = 0 //0:user 1:team
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        self.verifyTextField.text = "你好，我是\"\(NIMSDK.shared().loginManager.currentAccount())\""
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        verifyTextField.resignFirstResponder()
    }
    
    func setupNavigation(){
        self.navigationItem.title = "验证信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(didClickSend))
    }
    
    func didClickSend(){
        verifyTextField.resignFirstResponder()
        
        guard let txt = verifyTextField.text?.trimSpacesBeforeAndAfter(),txt.characters.count > 0 else {
            
            self.view.showHUDMsg(msg: "请输入验证信息")
            return
        }
        
        self.view.showHUDProgress()
        
        if type == 0 {
            let request = NIMUserRequest()
            request.userId = userOrTeamId
            request.operation = .request
            request.message = txt
            NIMSDK.shared().userManager.requestFriend(request) { (error) in
                self.view.hiddenAllMessage()
                
                if error == nil {
                    self.view.showHUDMsg(msg: "请求成功，等待对方验证")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    print(error!)
                    self.view.showHUDMsg(msg: "添加失败")
                }
            }
        }else if type == 1 {
            NIMSDK.shared().teamManager.apply(toTeam: userOrTeamId, message: txt, completion: { (error, status) in
                self.view.hiddenAllMessage()
                
                if error == nil {
                    self.view.showHUDMsg(msg: "请求成功，等待对方验证")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    print(error!)
                    self.view.showHUDMsg(msg: "添加失败")
                }
            })
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.didClickSend()
        
        return true
    }
}
