//
//  DataConversion.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/19.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation
import HandyJSON

/**
 *  Json转对象
 */
func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) ->MMBBaseModel {
    if jsonStr == "" || jsonStr.count == 0 {
        #if DEBUG
        print("jsonoModel:字符串为空")
        #endif
        return MMBBaseModel()
    }
    return modelType.deserialize(from: jsonStr)  as! MMBBaseModel
    
}

/**
 *  Json转数组对象
 */
func jsonArrayToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[MMBBaseModel] {
    if jsonArrayStr == "" || jsonArrayStr.count == 0 {
        #if DEBUG
        print("jsonToModelArray:字符串为空")
        #endif
        return []
    }
    var modelArray:[MMBBaseModel] = []
    let data = jsonArrayStr.data(using: String.Encoding.utf8)
    let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
    for people in peoplesArray! {
        modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
    }
    return modelArray
    
}

/**
 *  字典转对象
 */
func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> MMBBaseModel {
    if dictionStr.count == 0 {
        #if DEBUG
        print("dictionaryToModel:字符串为空")
        #endif
        return MMBBaseModel()
    }
    return modelType.deserialize(from: dictionStr) as! MMBBaseModel
}

/**
 *  对象转JSON
 */
func modelToJson(_ model:MMBBaseModel?) -> String {
    if model == nil {
        #if DEBUG
        print("modelToJson:model为空")
        #endif
        return ""
    }
    return (model?.toJSONString())!
}

/**
 *  对象转字典
 */
func modelToDictionary(_ model:MMBBaseModel?) -> [String:Any] {
    if model == nil {
        #if DEBUG
        print("modelToJson:model为空")
        #endif
        return [:]
    }
    return (model?.toJSON())!
}

// JSONString转换为字典

func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
    
    
}

/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}

//json转数组
func getArrayFromJSONString(jsonString:String) ->NSArray{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if array != nil {
        return array as! NSArray
    }
    return array as! NSArray
    
}

//数组转json
func getJSONStringFromArray(array:NSArray) -> String {
    
    if (!JSONSerialization.isValidJSONObject(array)) {
        print("无法解析出JSONString")
        return ""
    }
    
    let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}

//md5加密
extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}
