//
//  IMGroupedContacts.swift
//  NIMSwift
//
//  Created by 衡成飞 on 6/9/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit


class IMGroupedContacts: IMGroupedDataCollection {
    fileprivate var groupTitles:[String] = []
    fileprivate var groupMembers:[[NIMKitInfo]] = []
    
    override init(_ members:[Any]) {
        super.init(members)
        
        groupTitles.removeAll()
        groupMembers.removeAll()
        
        let account = NIMSDK.shared().loginManager.currentAccount()
        
        var tmp:[String:[NIMKitInfo]] = [:]
        for member  in members {
            if let m = member as? NIMUser {
                if account == m.userId {
                    continue
                }
                
               let info = NIMKit.shared().info(byUser: m.userId!, option: nil)
               let title = IMSpellingUtil.shareInstance.groupTitle((info!.showName)!)
                
                if let _ = tmp[title] {
                }else{
                    tmp[title] = []
                }
                tmp[title]?.append(info!)
            }
        }
        
        for (k,_) in tmp {
            groupTitles.append(k)
        }
        
        //title先排序，再取得对应的members
        sortGroupTitle()
        
        for t in groupTitles {
            groupMembers.append(tmp[t]!)
        }
        
        //每个分组内成员再进行排序
        sortGroupMember()
    }
    
    
    /**
     排序后的分组titles
     **/
    func sortedGroupTitles() -> [String] {
        return groupTitles
    }
    
    /**
     排序后的分组
     **/
    func sortedGroupMembers() -> [[NIMKitInfo]] {
        return groupMembers
    }
    
    /**
     分组数量
     **/
    override func groupCount() -> Int {
        return groupTitles.count
    }
    
    /**
     单个分组内，成员数量
     **/
    override func memberCountOfGroup(groupIndex: Int) -> Int {
        return groupMembers[groupIndex].count
    }
    
    /**
     获取某个分组下的成员
     **/
    func memberOfIndex(index: IndexPath) -> NIMKitInfo {
        return groupMembers[index.section][index.row]
    }
    
    /**
     删除某个分组下的成员
     **/
    func removeGroupMember(member: NIMKitInfo) {

    }
    
    /**
     分组title
     **/
    override func titleOfGroup(groupIndex: Int) -> String {
        return groupTitles[groupIndex]
    }
    
    /**
     分组title，升序排列
     **/
    fileprivate func sortGroupTitle(){
        groupTitles.sort { (k1, k2) -> Bool in
            if k1 < k2 {
                return true
            }
            return false
        }
    }
    
    /**
     分组成员，升序排列
     **/
    fileprivate func sortGroupMember() {
        
        if groupMembers.count <= 0 {
            return
        }
        
        for i in 0...groupMembers.count-1{
            groupMembers[i] = groupMembers[i].sorted{
                return NIMSpellingCenter.shared().spelling(for: $0.showName).shortSpelling < NIMSpellingCenter.shared().spelling(for: $1.showName).shortSpelling
            }
        }
    }
    
}
