//
//  QNUpload.swift
//  NIMSwift
//
//  Created by 衡成飞 on 5/26/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit
import Qiniu
import PromiseKit

class QNUpload: QNUploadManager {
    public static let shareInstance:QNUpload = {
        let instance = QNUpload()
        return instance!
    }()
    
    func upload(_ data: Data, _ key:String?, _ token:String,_ complete:((_ info:QNResponseInfo?,_ key:String?, _ resp:[AnyHashable : Any]?) -> Void)?){
        self.put(data, key: key, token: token, complete: { (info, key, resp) in
            if complete != nil {
                complete!(info,key,resp)
            }
            
        }, option: nil)
    }
        
}

class TMUpload {
    public static let shareInstance:TMUpload = {
        let instance = TMUpload()
        return instance
    }()
    
    /**
     *    生成随机key
     */
    func getRandomKey() -> String {
        return Date().toString("yyyyMMddHHmmssSSS") + "\(arc4random())"
    }
 
    /**
     *    上传单个图片到七牛
     *
     *    @param image             图片
     *    @param token             上传需要的token, 由服务器生成
     *    @param key               上传到云存储的key，为nil时表示是由七牛生成
     */
    func upload(_ image:UIImage, _ token:String,_ key:String? = nil) -> Promise<String>{
        return Promise{fulfill,reject in
            QNUpload.shareInstance.upload(UIImagePNGRepresentation(image)!, key, token) { (info, key, resp) in
                if let r = info?.isOK , r == true {
                    fulfill(resp!["key"] as! String)
                }else{
                    print(info.debugDescription)
                    reject(NSError(domain: "UploadError", code: 2001, userInfo: [NSLocalizedDescriptionKey: "上传失败"]))
                }
                
            }
        }
    }
    
}
