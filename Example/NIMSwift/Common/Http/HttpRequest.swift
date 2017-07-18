//
//  Extension.swift
//  宝约
//
//  Created by 衡成飞 on 10/18/16.
//  Copyright © 2016 qianwang. All rights reserved.
//

import UIKit
import ObjectMapper
import CFNetworkEngine
import AdSupport

public func request<T:Mappable>(
    _ method:CFHTTPMethod,
    _ URLServer:String,
    _ URLString:String,
    parameters:[String: Any]? = nil,
    encoding:CFHTTPParameterEncoding? = CFHTTPParameterEncoding.URL,
    headers: [String: String]? = nil,
    success:((_ statusCode:Int?,_ data:NSDictionary?,_ model:T?) -> Void)?,
    failure:((_ message:String) -> Void)?  = nil){
    
    var params:[String: Any]? = parameters
    if params == nil {
        params = [:]
    }
    
    let URL = URLServer + URLString
    
    //增加额外的头部
    var _headers:[String:String] = httpHeaders()
    if let h = headers {
        for (key,value) in h {
            _headers[key] = value
        }
    }
 
    //参数log
    if let p = params {
        var s = "?"
        for (key,value) in p {
            s = s + key + "=" + "\(value)" + "&"
        }
        
        let p1 = s.substring(to: s.characters.index(s.endIndex, offsetBy: -1))
        
        print("[" + Date().toString("yyyy-MM-dd HH:mm:ss.SSS") + "]  \(URL)\(p1)")
    }else{
        print("[" + Date().toString("yyyy-MM-dd HH:mm:ss.SSS") + "]  \(URL)")
    }
    
    var tmps = ""
    for (key,value) in _headers {
        tmps = tmps + key + "=" + "\(value)" + "\n"
    }
    print("header头部:\n\(tmps)")

    let requestClosure = {() -> Void in
        CFNetworkEngine.sharedInstance.request(method: method, URL, parameters: params, encoding: encoding, headers: _headers, success: { data in
            
            let m = Mapper<T>().map(JSON: data! as! [String : Any])
            var statusCode = 0
            if let c = data!.value(forKey: "code") as? Int {
                statusCode = c
            }
            if success != nil {
                success!(statusCode,data,m)
            }
        }, failure: { (message) in
            //print("\(message)")
            if failure != nil {
                failure!(message)
            }
        })
    }
    
    requestClosure()
}

func httpHeaders() -> [String:String] {
    let idfa:String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    let idfv:String = (UIDevice.current.identifierForVendor?.uuidString)!
    let version  = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        as! String
    
    let os = (UIDevice.current.systemName + UIDevice.current.systemVersion).replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
    
    let header:[String:String] = ["version":version,"device":modelName,"mobileOS":os,"idfv":idfv,"idfa":idfa]
    

    return header
}

var modelName: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8 , value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    switch identifier {
    case "iPod5,1":                                  return "iPod Touch 5"
    case "iPod7,1":                                  return "iPod Touch 6"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":    return "iPhone 4"
    case "iPhone4,1":                                return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
    case "iPhone8,4":                               return "iPhone SE"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
    case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
    case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
    case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
    case "AppleTV5,3":                              return "Apple TV"
    case "i386", "x86_64":                          return "Simulator"
    default:                                        return identifier
    }
}

