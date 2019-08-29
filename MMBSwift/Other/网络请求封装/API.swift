//
//  API.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/5.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation
import Moya

enum API {
    //登录
    case login(paramters:[String: Any])
    //验证码登录
    case loginByCmd(params:[String: Any])
    //登出
    case logout
    //获取验证码
    case getVerifyCode(telphone:String)
    //注册
    case register(params:[String: Any])
    //更改密码、忘记密码
    case changPassword(params:[String: Any])
    //验证原手机号
    case checkOldTel(params:[String: Any])
    //绑定新手机号
    case changeTel(params:[String: Any])
    //商家名称、简称、电话
    case getSubownerNameValue(owner_id : String)
    //商家信息查看
    case getSubownerInfo(owner_id : String)
}

extension API: TargetType {
    var task: Task {
        switch self {
        case .login(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getVerifyCode(let tel):
            return .requestParameters(parameters: ["telphone":tel], encoding: JSONEncoding.default)
        case .loginByCmd(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .register(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .changPassword(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .getSubownerNameValue(let ownerId):
            return .requestParameters(parameters: ["owner_id":ownerId], encoding: JSONEncoding.default)
        case .getSubownerInfo(let ownerId):
            return .requestParameters(parameters: ["owner_id":ownerId], encoding: JSONEncoding.default)
        case .checkOldTel(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .changeTel(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var path: String {
        switch self {
        case .logout:
            return "Logout"
            
        case .login:
            return "login"
            
        case .loginByCmd:
            return "loginByCmd"
            
        case .getVerifyCode:
            return "sendCmd"
            
        case .register:
            return "register"
            
        case .changPassword(params: _):
            return "changePsd"
            
        case .getSubownerNameValue(owner_id: _):
            return "getSubownerNameValue"
            
        case .getSubownerInfo(owner_id: _):
            return "getSubownerInfo"
            
        case .checkOldTel(params: _):
            return "checkOldTel"
            
        case .changeTel(params: _):
            return "changeTel"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        default:
            return .post
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
        var header = ["content-type":"application/json"]
        if dict != nil {
            let token : String = dict?["token"] as! String
            let userid : String = dict?["userId"] as! String
            let sid : String = dict?["sid"] as! String
            let bid : String = dict?["bid"] as! String
            let personid : String = dict?["personId"] as! String
            let ownerid : String = dict?["ownerId"] as! String
            header = ["content-type":"application/json","token":token,"userid":userid,"sid":sid,"bid":bid,"personid":personid,"ownerid":ownerid]
        }
        return header
    }
    
    var baseURL: URL {
        return URL.init(string: APIURL())!
    }
}
