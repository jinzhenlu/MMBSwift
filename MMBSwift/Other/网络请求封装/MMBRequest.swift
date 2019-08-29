//
//  MMBRequest.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/7.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit
import Alamofire

class MMBRequest: NSObject {
    
    static func requestByPost(functionId:String,
                             body:Any? = nil,
                             Success:@escaping (Any?)->Void ,
                             Failure:@escaping (Any?)->Void){
        let requestTool = MMBRequestTool(body: body)
        guard let jsonDict = requestTool.toJSON() else {
            return
        }
        guard let jsonString = requestTool.toJSONString() else {
            print("jsonDict is \(jsonDict)")
            return
        }
        print("request jsonString is \(jsonString)")
        
        var request = URLRequest(url: NSURL(string: AppConstants.requestUrl)! as URL)
        request.timeoutInterval = 30
        request.httpBody = jsonString.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        Alamofire.request(request).responseString { (responseString) in
            print("responseString is \(String(describing: responseString.value))")
            switch responseString.result{
            case .success(let value):
                let responseStr:String = value as String
                print("Alamofire.request \(functionId) responseStr is \(responseStr)")
                Success(value)
            case .failure(let error):
                MMBProgressHUD.mx_showText("网络请求失败")
                Failure(error)
            }
        }
    }
}

class MMBRequestTool: MMBBaseModel {
    
    let body:Any?
    
    init(body:Any? = nil) {
        self.body = body
    }
    
    required init() {
        self.body = nil
    }
}
