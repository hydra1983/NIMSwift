//
//  IMGroupedDataCollection.swift
//  NIMSwift
//
//  Created by 衡成飞 on 6/12/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

class IMGroupedDataCollection: NSObject {
    
    fileprivate var members:[Any]!
    fileprivate var sortedGroupTitles:[Any]!
    
    
    init(_ members:[Any]) {        
        self.members = members
    }
    
    func addGroupMember(member:Any){
        
    }
    
    
    func addGroupAboveWithTitle(_ title:String,_ members:[Any]){
        
    }
    
    func titleOfGroup(groupIndex:Int) -> String{
        return ""
    }
    
    func membersOfGroup(groupIndex:Int) -> [Any]{
        return [""]
    }
    
//    func memberOfIndex(index:IndexPath) -> Any {
//        return ""
//    }
    
    func groupCount() -> Int{
        return 0
    }
    
    func memberCountOfGroup(groupIndex:Int) -> Int{
        return 0
    }
}
