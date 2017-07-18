//
//  IMContactAddFriendController.swift
//  NIMSwift
//
//  添加好友
//
//  Created by 衡成飞 on 6/7/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMContactAddFriendController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "添加好友"
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_nav")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_nav")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        searchTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func cancel(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let text = textField.text?.trimSpacesBeforeAndAfter(),text.characters.count > 0   else {
            return false
        }
        
        
        searchUser(text)
        
        return true
    }
    
    
    func searchUser(_ searchText:String){

        self.view.showHUDProgress()
        
//        request(.GET, URLs.kServerApp, URLs.kURLSearch, parameters: ["key":searchText], encoding: nil, headers: nil, success: { (code, dict, model:BaseModel<SearchModel>?) in
//            if code == 0,let type = model?.data?.type, let info = model?.data?.info{
//                if type == 1 {
//                    NIMSDK.shared().userManager.fetchUserInfos([info.imId!]) { (user, error) in
//                        self.view.hiddenAllMessage()
//                        if error != nil {
//                            print(error!)
//                            self.view.showHUDMsg(msg: "获取用户信息失败")
//                        }else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMPersonalCardController") as! IMPersonalCardController
//                            vc.userId = info.imId!
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    }
//                }else if type == 2 || type == 3 {
//                    NIMSDK.shared().teamManager.fetchTeamInfo("\(info.groupId!)", completion: { (error, team) in
//                        self.view.hiddenAllMessage()
//                        if error != nil {
//                            print(error!)
//                            self.view.showHUDMsg(msg: "获取群信息失败")
//                        }else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMTeamCardController") as! IMTeamCardController
//                            vc.teamId = "\(info.groupId!)"
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                    })
//                }
// 
//                
//            }else if let msg = model?.message {
//                self.view.hiddenAllMessage()
//                self.view.showHUDMsg(msg: msg)
//            }
//            
//        }, failure: {msg in
//            self.view.hiddenAllMessage()
//        })
    }
    
}
