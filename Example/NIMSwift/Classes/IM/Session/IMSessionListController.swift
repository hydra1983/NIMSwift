//
//  IMSessionListController.swift
//  NIMSwift
//
//  会话列表
//
//  Created by 衡成飞 on 5/3/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import NIMSDK
import FTPopOverMenu_Swift

class IMSessionListController: NIMSessionListViewController {
    
    fileprivate var emptyTipLabel:UILabel!
    fileprivate var titleLabel:UILabel!
    fileprivate var subTitleLabel:UILabel!
    fileprivate var titleView:UIView!
    
    deinit {
        NIMSDK.shared().loginManager.remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupDelegate()
        setupNavigation()
        setupEmptyTip()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /*
     覆盖父类方法
     */
    override func refresh(_ reload: Bool) {
        super.refresh(reload)
        
        let info = NIMKit.shared().info(byUser: NIMSDK.shared().loginManager.currentAccount(), option: nil)
        
        subTitleLabel.text = info?.showName
        subTitleLabel.sizeToFit()
        subTitleLabel.center = titleLabel.center
        subTitleLabel.y = titleLabel.center.y + 10
        titleView.width = subTitleLabel.width
        
        emptyTipLabel.isHidden = self.recentSessions.count == 0 ? true:false
    }
    
    
    func setupDelegate(){
        NIMSDK.shared().loginManager.add(self)
    }
    
    func setupNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"contact_list"), style: .plain, target: self, action: #selector(didClickShowContactList(_:event:)))
        let allUnreadCount = NIMSDK.shared().systemNotificationManager.allUnreadCount()
        if allUnreadCount > 0 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"contact_list_msg")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didClickShowContactList(_:event:)))
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"add_contact"), style: .plain, target: self, action: #selector(didClickAddContact(_:event:)))
        
        titleLabel = UILabel()
        titleLabel.text = "网易云信"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        
        subTitleLabel = UILabel()
        subTitleLabel.textColor = UIColor.gray
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.text =  NIMSDK.shared().loginManager.currentAccount()

        subTitleLabel.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin]
        subTitleLabel.textAlignment = .center
        subTitleLabel.sizeToFit()
        
        titleView = UIView()
        titleView.width = subTitleLabel.width
        titleView.height = titleLabel.height + subTitleLabel.height
        titleLabel.x = (titleView.width - titleLabel.width) / 2.0
        subTitleLabel.y = titleLabel.center.y + 10
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subTitleLabel)
        self.navigationItem.titleView = titleView
    }
    
    func setupEmptyTip(){
        emptyTipLabel = UILabel()
        emptyTipLabel.text = "还没有会话，在通讯录中找个人聊聊吧"
        emptyTipLabel.textColor = UIColor.darkGray
        emptyTipLabel.font = UIFont.systemFont(ofSize: 16)
        emptyTipLabel.isHidden = self.recentSessions.count == 0 ? false:true
        tableView.isHidden = self.recentSessions.count == 0 ? true:false
        emptyTipLabel.sizeToFit()
        self.view.addSubview(emptyTipLabel)
    }
    
    /**
     添加好友
     
     */
    func didClickAddContact(_ sender:UIBarButtonItem, event: UIEvent){
        let config = FTConfiguration.shared
        config.textColor = UIColor.white
        config.backgoundTintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        config.borderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        config.menuWidth = 140
        config.menuSeparatorColor = UIColor.lightGray
        config.textAlignment = .left
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.menuRowHeight = 50
        config.cornerRadius = 6
        
        FTPopOverMenu.showForEvent(event: event, with: ["添加好友","发起群聊"], menuImageArray: ["add_friend","add_team","add_discuss"], done: { (index) in
            if index == 0 {
                let vc = UIStoryboard.init(name: "IM", bundle: nil).instantiateViewController(withIdentifier: "IMContactAddFriendController") as! IMContactAddFriendController
                self.navigationController?.pushViewController(vc, animated: true)
            }else if index == 1 {
                self.presentMemberSelector({ userIds in
                    
                    let option =  NIMCreateTeamOption()
                    option.name = "群聊"
                    option.type = .advanced
                    option.joinMode = .needAuth
                    option.postscript = "邀请你加入群组"
                    //option.clientCustomInfo = "{\"type\":\(IMTeamType.Team.rawValue)}"
                    self.view.showHUDProgress()
                    NIMSDK.shared().teamManager.createTeam(option, users: userIds as! [String], completion: { (error, teamId) in
                        self.view.hiddenAllMessage()
                        
                        if error == nil {
                            let session = NIMSession(teamId!, type: .team)
                            let vc = IMSessionController(session: session)!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            print(error!)
                            self.view.showHUDMsg(msg: "创建失败")
                        }
                    })
                    
                })
            }
        }) {
            
        }
    }
    
    /**
     通讯录
     */
    func didClickShowContactList(_ sender:UIBarButtonItem, event: UIEvent){
        let vc = UIStoryboard.init(name: "IM", bundle: nil).instantiateViewController(withIdentifier: "IMContactController") as! IMContactController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     创建群
     */
    func presentMemberSelector(_ block: ContactSelectFinishBlock?){
        let config = NIMContactFriendSelectConfig()
        let currentUserId = NIMSDK.shared().loginManager.currentAccount()
        config.filterIds = [currentUserId]
        config.needMutiSelected = true
        
        let vc = NIMContactSelectViewController(config: config)
        vc?.finshBlock = block
        vc?.show()
    }
    
}


// 事件触发回调
extension IMSessionListController{
    /**
     *  选中某一条最近会话时触发的事件回调
     *
     *  @param recent    最近会话
     *  @param indexPath 最近会话cell所在的位置
     *  @discussion      默认将进入会话界面
     */
    override func onSelectedRecent(_ recent: NIMRecentSession!, at indexPath: IndexPath!) {
        let vc = IMSessionController(session: recent.session)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     *  选中某一条最近会话的头像控件，触发的事件回调
     *
     *  @param recent    最近会话
     *  @param indexPath 最近会话cell所在的位置
     *  @discussion      默认将进入会话界面
     */
    override func onSelectedAvatar(_ recent: NIMRecentSession!, at indexPath: IndexPath!) {
//        let vc = UIStoryboard.init(name: "IM", bundle: nil).instantiateViewController(withIdentifier: "IMPersonalCardController") as! IMPersonalCardController
//        
//        vc.userId =  (recent.session?.sessionId)!
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// 会话管理器回调,NIMConversationManagerDelegate
extension IMSessionListController{
    
}

// 登录相关回调,NIMLoginManagerDelegate
extension IMSessionListController{
    override func onLogin(_ step: NIMLoginStep) {
        super.onLogin(step)
        
    }
    
//    override func onMultiLoginClientsChanged() {
//        super.onMultiLoginClientsChanged()
//    }
}

// 事件订阅协议
extension IMSessionListController: NIMEventSubscribeManagerDelegate{
    
}
