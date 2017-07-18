//
//  IMNewFriendCell.swift
//  NIMSwift
//
//  Created by 衡成飞 on 6/14/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMNewFriendCell: UITableViewCell {
    @IBOutlet weak var avatorImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var acceptButton:UIButton!
    @IBOutlet weak var addedLabel:UILabel!


    var acceptHandler:(() -> Void)?

    func setupUI(_ noti:NIMSystemNotification){
        acceptButton.isHidden = true
        addedLabel.isHidden = true
        addedLabel.text = "已添加"
        
        //是否显示接收按钮
        let handleStatus = noti.handleStatus
        var needHandle = false
        let info = NIMKit.shared().info(byUser: noti.sourceID!, option: nil)
        if noti.type == .friendAdd {
            let attachment = noti.attachment as! NIMUserAddAttachment
            if attachment.operationType == .request {
                needHandle = true
            }
            
            //显示好友信息
            nameLabel.text = info?.showName
            
            avatorImageView.image = UIImage(named: "avatar_user")
            if let u = info?.avatarUrlString,NSURL(string:u) != nil {
                avatorImageView.cf_setImage(url: NSURL(string:u)!, placeHolderImage: nil)
            }
        }else if noti.type == .teamApply {
            needHandle = true
            let team = NIMSDK.shared().teamManager.team(byId: noti.targetID!)
            nameLabel.text = "\(info!.showName!) 申请加入 \(team!.teamName!)"
            
            avatorImageView.image = UIImage(named: "team_default")
            if let u = team?.avatarUrl,NSURL(string:u) != nil {
                avatorImageView.cf_setImage(url: NSURL(string:u)!, placeHolderImage: UIImage(named: "team_default"))
            }
        }else if noti.type == .teamInvite {
            needHandle = true
            
            let team = NIMSDK.shared().teamManager.team(byId: noti.targetID!)
            if let n = team?.teamName {
                nameLabel.text = "\(info!.showName!) 邀请你加入 \(n) "
            }
            
            avatorImageView.image = UIImage(named: "team_default")
            if let u = team?.avatarUrl,NSURL(string:u) != nil {
                avatorImageView.cf_setImage(url: NSURL(string:u)!, placeHolderImage: UIImage(named: "team_default"))
            }
        }else if noti.type == .teamApplyReject || noti.type == .teamIviteReject{
            needHandle = false
            let team = NIMSDK.shared().teamManager.team(byId: noti.targetID!)
            nameLabel.text = "\(info!.showName!) 加入"
            if let n = team?.teamName {
                nameLabel.text = "\(info!.showName!) 加入 \(n)"
            }
            addedLabel.text = "已拒绝"
            
            avatorImageView.image = UIImage(named: "team_default")
            if let u = team?.avatarUrl,NSURL(string:u) != nil {
                avatorImageView.cf_setImage(url: NSURL(string:u)!, placeHolderImage: UIImage(named: "team_default"))
            }
            
        }
        
     
        
        if handleStatus == IMNotificationHandleType.Request.rawValue && needHandle {
            acceptButton.isHidden = false
            addedLabel.isHidden = true
        }else{
            acceptButton.isHidden = true
            addedLabel.isHidden = false
        }
        
        messageLabel.text = noti.postscript
        

    }
    
    @IBAction func didClickAccept(){
        if acceptHandler != nil {
            acceptHandler!()
        }
    }
}
