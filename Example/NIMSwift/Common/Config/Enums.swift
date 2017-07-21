//
//  Enums.swift
//  NIMSwift
//
//  Created by 衡成飞 on 6/24/17.
//  Copyright © 2017 qianwang365. All rights reserved.
//

import UIKit

enum IMNotificationHandleType: Int {
    case Request = 0,
    OK = 1,
    No = 2,
    OutOfDate = 3
}

protocol NIMSwift_Enum {
    var description: String { get }
}

enum HttpErrorCode: Int,NIMSwift_Enum{
    case InternetError  = 10000
    case PublicKeyError = 10001
    case AppLoginError = 30004 //服务器返回的error（自动登录用，只需要用户名和密码）
    case TokenInvalidError = 30006 //token失效
    case IMLoginError = 10002 //IM登录失败
    
    var description: String {
        switch self {
        case .InternetError:
            return "网路连接失败，请检查网络"
        case .PublicKeyError:
            return "Public key获取失败"
        case .AppLoginError:
            return "用户名或密码错误"
        case .IMLoginError:
            return "登录失败，请重新登录"
        case .TokenInvalidError:
            return "Token失效，请重新登录"
        }
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

