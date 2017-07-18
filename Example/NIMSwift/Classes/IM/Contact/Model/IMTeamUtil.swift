//
//  IMTeamUtil.swift
//  NIMSwift
//
//  团队Util
//
//  Created by 衡成飞 on 6/21/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMTeamUtil {
    public static let shareInstance:IMTeamUtil = {
        let instance = IMTeamUtil()
        return instance
    }()
    
    
    /** 获取所在的群列表 **/
    func fetchTeams() -> [NIMTeam]? {
        var teams:[NIMTeam] = []
        if let allTeams = NIMSDK.shared().teamManager.allMyTeams() {
            for t in allTeams {
                var client = 0
                if let type = t.clientCustomInfo?.toDictionary() {
                    client = type["type"] as! Int
                }
                if t.type == .advanced && client == 0 {
                    teams.append(t)
                }
            }
            return teams
        }
        
        return nil
    }
    
    /** 
     获取所在某个群／团队
     
     **/
    func fetchTeamOrGroupById(_ teamId:String) -> NIMTeam? {
        if let allTeams = NIMSDK.shared().teamManager.allMyTeams() {
            for t in allTeams {
                if t.teamId == teamId {
                    return t
                }
            }
        }
        
        return nil
    }

    /**
     是否在某个群／团队里
     
     **/
    func isInTeam(_ teamId:String) -> Bool {
        if let allTeams = NIMSDK.shared().teamManager.allMyTeams() {
            for t in allTeams {
                if t.teamId == teamId {
                    return true
                }
            }
        }
        
        return false
    }
}
