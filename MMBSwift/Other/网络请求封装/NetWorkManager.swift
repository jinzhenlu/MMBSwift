//
//  NetWorkManager.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/17.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Alamofire

//@_exported import HandyJSON
//超时时长
private var requestTimeOut:Double = 30
//成功的数据回调
typealias successCallback = ((String) -> (Void))
//失败的回调
typealias failedCallback = ((String) -> (Void))
//网络错误的回调
typealias errorCallback = (() -> (Void))

///网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: API) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    switch target {
        
    default:
        return endpoint
    }
}

///网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        //打印请求参数
        if let requestData = request.httpBody {
            let headerJson = getJSONStringFromDictionary(dictionary: request.allHTTPHeaderFields! as NSDictionary)
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数body"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")"+"\n"+"参数header"+"\(headerJson)" )
            
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
//loading的逻辑也可以直接放在网络处理里面
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
//    switch(changeType){
//    case .began:
//        print("开始请求网络")
//        
//    case .ended:
//        print("结束")
//    }
}

////网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider<API>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)


/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 请求成功的回调
//func NetWorkRequest(_ target: API, completion: @escaping successCallback ){
//    NetWorkRequest(target, completion: completion, failed: nil, errorResult: nil)
//}

/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功的回调
///   - failed: 请求失败的回调
func NetWorkRequest(_ target: API, completion: @escaping successCallback , failed:failedCallback?) {
    NetWorkRequest(target, completion: completion, failed: failed, errorResult: nil)
}


///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - completion: 成功
///   - failed: 失败
///   - error: 错误
func NetWorkRequest(_ target: API, completion: @escaping successCallback , failed:failedCallback?, errorResult:errorCallback?) {
    //先判断网络是否有链接 没有的话直接返回--代码略
    if !isNetworkConnect{
        print("提示用户网络似乎出现了问题")
        return
    }
    //这里显示loading图
    CBToast.showToastAction()
    Provider.request(target) { (result) in
        //隐藏hud
        CBToast.hiddenToastAction()
        switch result {
        case let .success(response):
            do {
                let jsonData = try JSON(data: response.data)
                print(jsonData)
                //               这里的completion和failed判断条件依据不同项目来做，为演示demo我把判断条件注释了，直接返回completion。
                
                completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                
//                print("flag不为1000 HUD显示后台返回message"+"\(jsonData[RESULT_MESSAGE].stringValue)")
                
                //                if jsonData[RESULT_CODE].stringValue == "1000"{
                //                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                //                }else{
                //                if failed != nil{
                //                    failed(String(data: response.data, encoding: String.Encoding.utf8)!)
                //                }
                //                }
                
            } catch {
            }
        case let .failure(error):
            guard let error = error as? CustomStringConvertible else {
                //网络连接失败，提示用户
                print("网络连接失败")
                CBToast.showToastAction(message: "网络连接失败")
                break
            }
            if errorResult != nil {
                errorResult!()
            }
        }
    }
}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}
