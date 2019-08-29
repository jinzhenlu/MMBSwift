//
//  UserDefaultsTool.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/19.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation

protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue==String {
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
    
    static func set(value: NSDictionary?, forKey key: defaultKeys){
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func dictionary(forKey key: defaultKeys) -> NSDictionary? {
        let aKey = key.rawValue
        return UserDefaults.standard.dictionary(forKey: aKey) as NSDictionary?
    }
    
    static func remove(forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.removeObject(forKey: aKey)
    }
}

extension UserDefaults {
    //登录后返回的信息
    struct AccountInfo : UserDefaultsSettable {
        enum defaultKeys : String {
//            case token
//            case userId
//            case sid
//            case bid
//            case personId          //职员id
//            case personName
//            case personTel
//            case ownerId           //主账号id
//            case owner_name
//            case username          //用户名
//            case im_nick           //融云昵称
//            case avatar
//            case customer_type_id  //客户分类id
//            case supplier_type_id  //供应商分类id
//            case mobile
//            case user_acctount     //登录账号
//            case password          //登录密码
//            case station           //岗位
//            case tel
//            case rcIMUserId        //融云上的用户id
            case userInfo
        }
    }
    
    //其他本地存储属性
    struct OtherDefaulst : UserDefaultsSettable {
        enum defaultKeys : String {
            case one
        }
    }
}

//常用信息
func myOwnerId() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["ownerId"] as! String
    }
    return ""
}

func myPersonId() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["personId"] as! String
    }
    return ""
}

func mySid() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["sid"] as! String
    }
    return ""
}

func myBid() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["bid"] as! String
    }
    return ""
}

func myUserId() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["userId"] as! String
    }
    return ""
}
func myStaffName() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["personName"] as! String
    }
    return ""
}
//我的职位
func myStation() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["station"] as! String
    }
    return ""
}
//我的客户维度分类id
func myCustomer_type_id() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["customer_type_id"] as! String
    }
    return ""
}
//我的供应商维度分类id
func mySup_type_id() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["supplier_type_id"] as! String
    }
    return ""
}
//是否客户分类管理员 1：是 0:否
func myIsCustomerAdmin() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["isCustomerAdmin"] as! String
    }
    return ""
}
//是否供应商分类管理员 1：是 0:否
func myIsSupAdmin() -> String{
    let dict = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
    if dict != nil {
        return dict?["isSupAdmin"] as! String
    }
    return ""
}

