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

        let infoId = searchText.trimSpacesBeforeAndAfter()
 
        self.view.showHUDProgress()
        
        NIMSDK.shared().userManager.fetchUserInfos([infoId]) { (user, error) in
            if user == nil {
                self.view.showHUDMsg(msg: "搜索不到人或群")
            }
            if error != nil {
                print(error!)
                NIMSDK.shared().teamManager.fetchTeamInfo(infoId, completion: { (error, team) in
                    self.view.hiddenAllMessage()
                    if error != nil {
                        print(error!)
                        self.view.showHUDMsg(msg: "搜索失败")
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMTeamCardController") as! IMTeamCardController
                        vc.teamId = infoId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }else if user != nil{
                self.view.hiddenAllMessage()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMPersonalCardController") as! IMPersonalCardController
                vc.userId = infoId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
     }
    
}
