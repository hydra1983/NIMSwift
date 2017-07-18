//
//  IMContactController.swift
//  NIMSwift
//
//  通讯录
//
//  Created by 衡成飞 on 6/9/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import CFWebImage

class IMContactController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    //未读信息数量
    var allUnreadCount:Int = 0
    
    //我的好友列表
    var myFriends:IMGroupedContacts?
    
    //顶部群列表
    var topTitles:[[String:String]] = [
        [
            "icon": "icon_message_normal",
            "title": "新的朋友",
            "vc": "IMNewFriendController",
            "badge":"\(0)"
        ],[
            "icon": "icon_team_advance_normal",
            "title": "群",
            "vc": ""
        ]
    ]
    
    deinit {
        NIMSDK.shared().systemNotificationManager.remove(self)
        NIMSDK.shared().loginManager.remove(self)
        NIMSDK.shared().userManager.remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigation()
        setupDelegate()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupNavigation(){
        self.navigationItem.title = "通讯录"
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_nav")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_nav")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupDelegate(){
        NIMSDK.shared().systemNotificationManager.add(self)
        NIMSDK.shared().loginManager.add(self)
        NIMSDK.shared().userManager.add(self)
    }
    
    func prepareData(){
        
        //获取好友列表
        let friends = NIMSDK.shared().userManager.myFriends()
        if let f = friends {
            myFriends = IMGroupedContacts(f)
        }
        
        //未读信息数量
        allUnreadCount = NIMSDK.shared().systemNotificationManager.allUnreadCount()
        topTitles[0]["badge"] = "\(allUnreadCount)"
    }
    
}

extension IMContactController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let n = myFriends?.groupCount() {
            return n + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return topTitles.count
        }
        if let n = myFriends?.memberCountOfGroup(groupIndex: section - 1){
            return n
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        return myFriends?.titleOfGroup(groupIndex: section - 1)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Top Cell", for: indexPath)
            
            
            cell.contentView.subviews.flatMap{$0 as? UIImageView}.first?.image = UIImage(named: topTitles[indexPath.row]["icon"]!)
            cell.contentView.subviews.flatMap{$0 as? UILabel}.filter{$0.tag == 0}.first?.text = topTitles[indexPath.row]["title"]
            
            cell.contentView.subviews.flatMap{$0 as? UILabel}.filter{$0.tag == 1}.first?.isHidden = true
            if let b =  topTitles[indexPath.row]["badge"],Int(b)! > 0 {
                cell.contentView.subviews.flatMap{$0 as? UILabel}.filter{$0.tag == 1}.first?.text = b
                cell.contentView.subviews.flatMap{$0 as? UILabel}.filter{$0.tag == 1}.first?.isHidden = false
            }
            
            return cell
        }
        
        let idx = IndexPath(row: indexPath.row, section: indexPath.section - 1)
        let m = myFriends?.memberOfIndex(index: idx)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell", for: indexPath)
        
        cell.contentView.subviews.flatMap{$0 as? UILabel}.first?.text = m?.showName
        if let u = m?.avatarUrlString,NSURL(string: u) != nil {
            cell.contentView.subviews.flatMap{$0 as? UIImageView}.first?.cf_setImage(url: NSURL(string: u)!, placeHolderImage: UIImage(named:"avator_default"))
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let row =  indexPath.row
            if row == 0{
                let vcName = topTitles[indexPath.row]["vc"]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: vcName!)
                
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if row == 1{
                let vcBase = self.storyboard?.instantiateViewController(withIdentifier: "IMTeamListControllerBase") as! IMTeamListControllerBase
                object_setClass(vcBase, IMTeamListController.self)
                let vc = vcBase as! IMTeamListController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        let idx = IndexPath(row: indexPath.row, section: indexPath.section - 1)
        let m = myFriends?.memberOfIndex(index: idx)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMPersonalCardController") as! IMPersonalCardController
        vc.userId = m!.infoId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //添加索引列
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return myFriends?.sortedGroupTitles()
    }
    
    //索引列点击事件
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index + 1
    }
    
    //划动cell是否出现del按钮
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    //删除好友
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let idx = IndexPath(row: indexPath.row, section: indexPath.section - 1)
        let m = myFriends?.memberOfIndex(index: idx)
        
        let deleteAction = UITableViewRowAction(style: .default, title: "删除", handler: {action in
            let act = UIAlertController(title: "删除好友", message: "删除好友后，将同时解除双方的好友关系", preferredStyle: .alert)
            act.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            act.addAction(UIAlertAction(title: "确定", style: .default, handler: {_ in
                self.view.showHUDProgress()
                NIMSDK.shared().userManager.deleteFriend(m!.infoId, completion: { (error) in
                    self.view.hiddenAllMessage()
                    if error != nil {
                        print(error!)
                        self.view.showHUDMsg(msg: "删除失败")
                    }
                })
            }))
            self.present(act, animated: true, completion: nil)
        })
        
        return [deleteAction]
    }
 
}

//系统通知回调
extension IMContactController:NIMSystemNotificationManagerDelegate{
    func onSystemNotificationCountChanged(_ unreadCount: Int) {
        self.prepareData()
        self.tableView.reloadData()
    }
}

//登录相关回调
extension IMContactController:NIMLoginManagerDelegate{
    func onLogin(_ step: NIMLoginStep) {
        if step == .syncOK {
            self.prepareData()
            self.tableView.reloadData()
        }
    }
}

//好友协议委托
extension IMContactController:NIMUserManagerDelegate{
    func onUserInfoChanged(_ user: NIMUser) {
        self.prepareData()
        self.tableView.reloadData()
    }
    
    func onFriendChanged(_ user: NIMUser) {
        self.prepareData()
        self.tableView.reloadData()
    }
    
    func onBlackListChanged() {
        self.prepareData()
        self.tableView.reloadData()
    }
    
    func onMuteListChanged() {
        self.prepareData()
        self.tableView.reloadData()
    }
}
