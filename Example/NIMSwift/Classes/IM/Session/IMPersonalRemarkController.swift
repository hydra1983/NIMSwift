//
//  IMPersonalRemarkController.swift
//  NIMSwift
//
//  备注信息
//
//  Created by 衡成飞 on 6/7/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMPersonalRemarkController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var remarkTextField:UITextField!
    
    var user:NIMUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "备注信息"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(remark))
        
        remarkTextField.becomeFirstResponder()
        remarkTextField.text = user.alias
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        remarkTextField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        
        remark()
        
        return true
    }
    
    
    func remark(){
        guard let text = remarkTextField.text?.trimSpacesBeforeAndAfter(),text.characters.count > 0   else {
            return
        }
     
        self.view.showHUDProgress()
        self.user.alias = text
        
        NIMSDK.shared().userManager.update(self.user) { (error) in
            self.view.hideHUDMsg()
            if error != nil {
                print(error!)
                self.view.showHUDMsg(msg: "添加备注失败，请重新尝试")
            }else{
                self.navigationController?.view.showHUDMsg(msg: "设置备注成功")
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
