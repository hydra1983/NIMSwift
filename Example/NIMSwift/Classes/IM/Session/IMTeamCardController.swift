//
//  IMTeamCardController.swift
//  NIMSwift
//
//  群／团队资料页面
//
//  Created by 衡成飞 on 6/7/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMTeamCardController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView:UITableView!
    
    var headerView:UIView!
    var footerView:UIView!
    
    
    //传入参数
    var teamId:String!
    
    fileprivate var team:NIMTeam?
    
    deinit {
        NIMSDK.shared().teamManager.remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupTableView()
        setupDelegate()
        requestTeamInfo()
    }
    
    func setupNav(){
        self.navigationItem.title = "详细资料"
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_nav")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_nav")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupDelegate(){
        NIMSDK.shared().teamManager.add(self)
    }
    
    func setupTableView(){
        tableView.tableHeaderView?.height = 100.0
        tableView.tableFooterView?.height = 150.0
        headerView = tableView.tableHeaderView
        footerView = tableView.tableFooterView
        
        let friendButton = footerView.subviews.flatMap{$0 as? UIButton}.filter{$0.tag == 0}.first
        
        let isMember = IMTeamUtil.shareInstance.isInTeam(teamId)

        if isMember {
            friendButton?.setTitle("发消息", for: .normal)
            friendButton?.addTarget(self, action: #selector(didClickSendMessage), for: .touchUpInside)
        }else{
            friendButton?.setTitle("加入群组", for: .normal)
            friendButton?.addTarget(self, action: #selector(didClickAddFriend), for: .touchUpInside)
        }
        
    }
    
    func refresh(){
        if let h = team?.avatarUrl,NSURL(string: h.encodingUrlQueryAllowed()) != nil {
            headerView.subviews.flatMap{$0 as? UIImageView}.first?.cf_setImage(url:NSURL(string:h.encodingUrlQueryAllowed())! , placeHolderImage: UIImage(named:"avator_default"))
        }
        
        headerView.subviews.flatMap{$0 as? UILabel}.forEach{ v in
            if v.tag == 0 {
                v.text = self.team?.teamName
            }else if v.tag == 1 {
                v.text = self.teamId
            }
        }
        
        self.tableView.reloadData()
    }
    
    func requestTeamInfo(){
        self.view.showHUDProgress()
        
        NIMSDK.shared().teamManager.fetchTeamInfo(teamId!) { (error, team) in
            self.view.hiddenAllMessage()
            if error != nil {
                self.view.showHUDMsg(msg: "获取群信息失败")
            }else{
                self.team = team
                self.refresh()
            }
        }
    }

    
    // 发送消息
    func didClickSendMessage(){
        let session = NIMSession.init(self.teamId, type: .team)
        let vc = IMSessionController(session: session)!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        let nav = self.navigationController
        nav?.viewControllers = [nav!.viewControllers[0],vc]
    }
    
    // 添加好友
    func didClickAddFriend(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IMAddFriendVerifyController") as! IMAddFriendVerifyController
        vc.userOrTeamId = teamId
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - NIMUserManagerDelegate
extension IMTeamCardController:NIMTeamManagerDelegate{
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
