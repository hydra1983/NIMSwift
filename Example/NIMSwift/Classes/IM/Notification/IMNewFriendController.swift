//
//  IMNewFriendController.swift
//  NIMSwift
//
//  新的朋友页面
//
//  Created by 衡成飞 on 6/14/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMNewFriendController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    let maxNotificationCount:Int = 1000
    var notifications:[NIMSystemNotification]?
    //    var shouldMarkAsRead:Bool = false
    
    deinit {
        NIMSDK.shared().systemNotificationManager.markAllNotificationsAsRead()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "新的朋友"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clearAll))
        
        self.tableView.tableFooterView = UIView()
        
        let system = NIMSDK.shared().systemNotificationManager
        system.add(self)
        notifications = system.fetchSystemNotifications(nil, limit: maxNotificationCount)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NIMSDK.shared().systemNotificationManager.markAllNotificationsAsRead()
    }
    
    func clearAll(){
        NIMSDK.shared().systemNotificationManager.deleteAllNotifications()
        notifications?.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let n = notifications?.count {
            return n
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IMNewFriendCell
        
        let m = notifications![indexPath.row]
        cell.setupUI(m)
        cell.acceptHandler = {
            self.view.showHUDProgress()
            
            if m.type == .friendAdd {
                let request = NIMUserRequest()
                request.userId = m.sourceID!
                request.operation = .verify
                
                NIMSDK.shared().userManager.requestFriend(request, completion: { (error) in
                    self.view.hiddenAllMessage()
                    if error == nil {
                        self.view.showHUDMsg(msg: "验证成功")
                        m.handleStatus = IMNotificationHandleType.OK.rawValue
                    }else{
                        print(error!)
                        self.view.showHUDMsg(msg: "验证失败，请重试")
                    }
                    self.tableView.reloadData()
                })
            }else if m.type == .teamApply{
                NIMSDK.shared().teamManager.passApply(toTeam: m.targetID!, userId: m.sourceID!, completion: { (error, status) in
                    self.view.hideHUDMsg()
                    if error == nil {
                        m.handleStatus = IMNotificationHandleType.OK.rawValue
                    }else{
                        print(error!)
                        self.view.showHUDMsg(msg: "添加失败，请重试")
                    }
                    self.tableView.reloadData()
                })
            }else if m.type == .teamInvite{
                NIMSDK.shared().teamManager.acceptInvite(withTeam: m.targetID!, invitorId: m.sourceID!, completion: { (error) in
                    self.view.hideHUDMsg()
                    if error == nil {
                        m.handleStatus = IMNotificationHandleType.OK.rawValue
                    }else{
                        print(error!)
                        self.view.showHUDMsg(msg: "添加失败，请重试")
                    }
                    self.tableView.reloadData()
                })
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "删除", handler: {action in
            
            let noti = self.notifications![indexPath.row]
            
            self.notifications!.remove(at: indexPath.row)
            NIMSDK.shared().systemNotificationManager.delete(noti)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        return [deleteAction]
    }
}

//系统通知回调
extension IMNewFriendController:NIMSystemNotificationManagerDelegate{
    func onReceive(_ notification: NIMSystemNotification) {
        //先遍历当前列表中，是否已存在
        if notifications != nil {
            //添加好友请求
            if notification.type == .friendAdd {
                let isEmpty = notifications!.filter{$0.sourceID == notification.sourceID}.isEmpty
                if isEmpty {
                    notifications?.insert(notification, at: 0)
                    self.tableView.reloadData()
                }
            }else if notification.type == .teamApply {
                let isEmpty = notifications!.filter{$0.sourceID == notification.sourceID}.isEmpty
                if isEmpty {
                    notifications?.insert(notification, at: 0)
                    self.tableView.reloadData()
                }
            }
        }else{
            notifications = []
            notifications?.append(notification)
        }
    }
}
