//
//  MMBProgressHUD.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/7.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit
import SVProgressHUD

class MMBProgressHUD: NSObject {
    class func mx_initHUD() {
        SVProgressHUD.setBackgroundColor(RGBA(r: 0, g: 0, b: 0, a: 0.7))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        ///设置用户是不是需要其他操作（显示的时候）
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
        //设置显示时间
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        
    }
    //成功
    class func mx_showSucessWithStatus(_ string : String) {
        self.MXProgressHUDshow(.sucess, status: string)
    }
    //只展示文字
    class func mx_showText(_ string : String) {
        self.MXProgressHUDshow(.onlyText, status: string)
    }
    //失败
    class func mx_showErrorWithObject(_ error : NSError){
        self.MXProgressHUDshow(.errorObject, status: nil, error: error)
        
    }
    
    //失败 ： string
    class func mx_showErrorWithStatus(_ string : String) {
        self.MXProgressHUDshow(.errorstring, status: string)
    }
    //菊花
    class func mx_showWithStatus(_ string : String) {
        self.MXProgressHUDshow(.onlyText, status: string)
    }
    // 警告
    class func mx_showWaringWithStatus(_ string : String) {
        self.MXProgressHUDshow(.info, status: string)
    }
    
    //loading 视图封装
    class func mx_loading(isShow:Bool ,showText : String? = "正在请求数据...") {
        
        if isShow == true {
            self.MXProgressHUDshow(.loading, status: showText ?? "")
        }else{
            self.ts_dismiss(showText ?? "")
        }
        
    }
    
    
    
    class func ts_dismiss(_ string : String){
        SVProgressHUD.dismiss()
        
    }
    
    fileprivate class func  MXProgressHUDshow(_ type : HUDType,status : String? = nil ,error : NSError? = nil ){
        
        switch type {
        case .sucess:
            SVProgressHUD.showSuccess(withStatus: status)
            break
        case .errorObject:
            guard let newerror = error else {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
                return
            }
            if newerror.localizedFailureReason == nil {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
            }else{
                SVProgressHUD.showError(withStatus: error?.localizedFailureReason)
                
            }
            break
        case .errorstring:
            SVProgressHUD.showError(withStatus: status)
            
            break
        case .info :
            SVProgressHUD.showInfo(withStatus: status)
            break
        case .loading :
            SVProgressHUD.show(withStatus: status)
            break
        case .onlyText :
            SVProgressHUD.show(UIImage(), status: status)
            break
            
        }
        
    }
    fileprivate enum HUDType : Int{
        case sucess, errorObject,errorstring,info,loading,onlyText
        
    }
}
