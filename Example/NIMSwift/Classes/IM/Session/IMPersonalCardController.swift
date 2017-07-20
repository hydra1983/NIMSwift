//
//  IMPersonalCardController.swift
//  NIMSwift
//
//  个人资料页面
//
//  Created by 衡成飞 on 6/7/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMPersonalCardController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    var headerView:UIView!
    var footerView:UIView!
    
    
    //传入参数(IM的account)
    var userId:String!
    
    fileprivate var userInfo:NIMUser?
    
    fileprivate var user:NIMUser?
    fileprivate var isAdded:Bool = false
    
    deinit {
        NIMSDK.shared().userManager.remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNav()
        
        setupDelegate()
        requestUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
    }
    
    func setupNav(){
        self.navigationItem.title = "详细资料"
    }
    
    func setupDelegate(){
        NIMSDK.shared().userManager.add(self)
    }
    
    func setupTableView(){
        tableView.tableHeaderView?.height = 100.0
        tableView.tableFooterView?.height = 150
        headerView = tableView.tableHeaderView
        footerView = tableView.tableFooterView
        
        let friendButton = footerView.subviews.flatMap{$0 as? UIButton}.filter{$0.tag == 0}.first
        
        let deleteButton = footerView.subviews.flatMap{$0 as? UIButton}.filter{$0.tag == 1}.first
        
        let isMe = self.userId == NIMSDK.shared().loginManager.currentAccount() ? true:false
        let isMyfriend = NIMSDK.shared().userManager.isMyFriend(self.userId)
        
        deleteButton?.isHidden = !isMyfriend
        deleteButton?.addTarget(self, action: #selector(didClickDeleteFriend), for: .touchUpInside)
        if isMe || isMyfriend {
            self.isAdded = true
            friendButton?.setTitle("发消息", for: .normal)
            friendButton?.addTarget(self, action: #selector(didClickSendMessage), for: .touchUpInside)
        }else{
            self.isAdded = false
            friendButton?.setTitle("加为好友", for: .normal)
            friendButton?.addTarget(self, action: #selector(didClickAddFriend), for: .touchUpInside)
        }
        
    }
    
    func refresh(){
        let info = NIMKit.shared().info(byUser: userId, option: nil)
        if let h = info?.avatarUrlString,NSURL(string: h.encodingUrlQueryAllowed()) != nil {
            headerView.subviews.flatMap{$0 as? UIImageView}.first?.cf_setImage(url:NSURL(string:h.encodingUrlQueryAllowed())! , placeHolderImage: UIImage(named:"avator_default"))
        }
        
        headerView.subviews.flatMap{$0 as? UILabel}.forEach{ v in
            if v.tag == 0 {
                if let alias = user?.alias {
                    v.text = alias
                }else{
                    v.text = user?.userInfo?.nickName
                }
            }else if v.tag == 1 {
                v.text = self.userId
            }
        }
        
        self.tableView.reloadData()
    }
    
    func requestUserInfo(){
        self.view.showHUDProgress()
        
        NIMSDK.shared().userManager.fetchUserInfos([userId]) { (user, error) in
            self.view.hiddenAllMessage()
            if error != nil {
                self.view.showHUDMsg(msg: "获取用户信息失败")
            }else if user != nil{
                self.user = user![0]
                self.refresh()
            }
        }
    }
    
    // 删除好友
    func didClickDeleteFriend(){
        let act = UIAlertController(title: "删除好友", message: "删除好友后，将同时解除双方的好友关系", preferredStyle: .alert)
        act.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        act.addAction(UIAlertAction(title: "确定", style: .default, handler: {_ in
            self.view.showHUDProgress()
            NIMSDK.shared().userManager.deleteFriend(self.userId, completion: { (error) in
                self.view.hiddenAllMessage()
                if error != nil {
                    print(error!)
                    self.view.showHUDMsg(msg: "删除失败")
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }))
        self.present(act, animated: true, completion: nil)
    }
    
    // 发送消息
    func didClickSendMessage(){
        let session = NIMSession.init(self.userId, type: .P2P)
        let vc = IMSessionController(session: session)!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        let nav = self.navigationController
        nav?.viewControllers = [nav!.viewControllers[0],vc]
    }
    
    // 添加好友
    func didClickAddFriend(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMAddFriendVerifyController") as! IMAddFriendVerifyController
        vc.userOrTeamId = userId
        vc.type = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && !self.isAdded{
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "remark cell", for: indexPath)
            
            if let alias = user?.alias {
                cell.contentView.subviews.first?.subviews.flatMap{$0 as? UILabel}.filter{$0.tag == 1}.first?.text = alias
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "search cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMPersonalRemarkController") as! IMPersonalRemarkController
            vc.user = self.user!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - NIMUserManagerDelegate
extension IMPersonalCardController:NIMUserManagerDelegate{
    func onUserInfoChanged(_ user: NIMUser) {
        self.refresh()
    }
    
    func onFriendChanged(_ user: NIMUser) {
        self.refresh()
    }
    
    func onBlackListChanged() {
        self.refresh()
    }
    
    func onMuteListChanged() {
        self.refresh()
    }
}
