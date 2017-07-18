//
//  Extension.swift
//  NIMSwift
//
//  Created by 黄海龙 on 2017/6/20.
//  Copyright © 2017年 qianwang365. All rights reserved.
//

import UIKit
import CFWebView
import MapKit

extension Date {
    
    // MARK: - 时间戳字符串转换为格式化时间
    func stampStrToFormat(_ timeStamp:String,format:String) -> String {
        
        let timeInterval = TimeInterval(timeStamp)! / 1000
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /**
     日期转换为相应格式的字符串
     */
    func toString(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    func todayStamp() -> String {
        return "\(self.timeIntervalSince1970*1000)"
    }
}

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}

extension Array {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}
