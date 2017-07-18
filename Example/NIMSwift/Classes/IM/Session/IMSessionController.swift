//
//  IMSessionController.swift
//  NIMSwift
//
//  会话窗口
//
//  Created by 衡成飞 on 6/6/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMSessionController: NIMSessionViewController {
    
    deinit {
        NIMSDK.shared().systemNotificationManager.remove(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        
        setupNav()
        setupDelegate()
    }

    func setupDelegate(){
        NIMSDK.shared().systemNotificationManager.add(self)
    }
    
    func setupNav(){
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back_nav")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_nav")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = self.sessionTitle()
        if session.sessionType == .P2P {
            //            if session.sessionId != NIMSDK.shared().loginManager.currentAccount() {
            //                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"person_info"), style: .plain, target: self, action: #selector(didClickPersonal))
            //            }
        }else if session.sessionType == .team ||  session.sessionType == .chatroom{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"team_info"), style: .plain, target: self, action: #selector(didClickTeam))
        }
    }
    
    func didClickPersonal() {
        
    }
    
    // 点击头像
    override func onTapAvatar(_ userId: String!) -> Bool {
        let vc = UIStoryboard.init(name: "IM", bundle: nil).instantiateViewController(withIdentifier: "IMPersonalCardController") as! IMPersonalCardController
        
        vc.userId =  userId
        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }
    
    func didClickTeam() {
        let team = NIMSDK.shared().teamManager.team(byId: self.session.sessionId)
        
        if team?.type == .normal {
            //暂不处理
        }else if team?.type == .advanced {
            let vc = NIMAdvancedTeamCardViewController(team: team)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

//系统通知回调
extension IMSessionController:NIMSystemNotificationManagerDelegate{
    func onReceive(_ notification: NIMSystemNotification) {
        
    }
    
    func onReceive(_ notification: NIMCustomSystemNotification) {
        
    }
}
