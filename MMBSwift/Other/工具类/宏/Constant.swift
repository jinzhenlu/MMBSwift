//
//  Const.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/7/29.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation
import UIKit

enum AppConstants {
    //MARK: - 日志输出
    static let LogDebug: Bool = true
    //接口地址
    enum AppInterfaceAddress {
        //测试环境
        static let DebugUrl_8080 = "http://47.104.75.80:8080/"
        //测试环境2
        static let DebugUrl_8180 = "http://47.104.75.80:8180/"
        //线上环境
        static let ProductUrl = "https://buy.emeixian.com/"
    }
    
    static let requestUrl = AppInterfaceAddress.DebugUrl_8080
    
    enum AppKey {
        //友盟
        static let UMeng = ""
        //微信
        static let WXApiID = "wxe4be72167ceb34c1"
        //极光推送
        static let JGAppkey = "1a13950c3ba9e5c2fca64529"
        //百度地图
        static let BDAppkey = "99H6NMSce2nn0HBg75PZN737oRSnr96I"
        //融云
        static let RYAppkey = "8brlm7uf8zh13"
    }
    
    enum ErrorType {
        static let ServerError = "服务器异常"
    }
    
}

func APIURL() -> String {
    let requestUrl : String = AppConstants.requestUrl + "api.php/"
    return requestUrl
}

//MARK: - 日志输出
// <T>: 为泛型，外界传入什么就是什么
func BJDLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    
    if AppConstants.LogDebug {
        
        print("\(method)[\(line)]:\(message)")
        
    }
    
}

//frame相关
public enum AppFrame{
    
    static let kScreenBounds = UIScreen.main.bounds
    
    static let kScreenWidth = kScreenBounds.size.width
    
    static let kScreenHeight = kScreenBounds.size.height
    
    //状态栏高度
    static let kHeight_StatusBar = (iPhoneX || iPhoneXR || iPhoneXSMAX) ? 44 : 20
    //状态栏+导航栏高度
    static let kHeight_StatusBarAndNavigationBar = (iPhoneX || iPhoneXR || iPhoneXSMAX) ? 88 : 64
    //底部安全区域远离高度
    static let kBottomSafeHeight = (iPhoneX || iPhoneXR || iPhoneXSMAX) ? 34 : 0
    //tabbar+安全区高度
    static let kHeight_TabBar = (iPhoneX || iPhoneXR || iPhoneXSMAX) ? 83 : 49
}

//颜色相关
public enum AppColor {
    //APP黑色
    static let black = RGB0X(hexValue: 0x333333)
    //APP深灰色
    static let darkgGray = RGB0X(hexValue: 0x666666)
    //APP灰色
    static let gray = RGB0X(hexValue: 0xf9f9f9)
    //APP轻灰色
    static let lightGray = RGB0X(hexValue: 0xf5f5f5)
    //app青灰色
    static let lightGray2 = RGB(242, g: 242, b: 246)
    //APP蓝色背景
    static let blue = RGB(68, g: 155, b: 243)
}

/**
 *  随机色
 */
func ColorRandom() -> UIColor {
    
    return RGB(CGFloat(arc4random()%255), g: CGFloat(arc4random()%255), b: CGFloat(arc4random()%255))
}

func RGB(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func HEXA(hexValue: Int, a: CGFloat) -> (UIColor) {
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                   alpha: a)
}

func RGB0X(hexValue: Int) -> (UIColor) {
    
    return HEXA(hexValue: hexValue, a: 1.0)
    
}

func FONT(font: CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: font)
    
}

//通知相关
public enum AppNotification {
    //刷新个人中心信息
    static let kRefreshPersonal = "refreshPersonalView"
}

//机型相关
//iphone4系列
let iPhone4:Bool = __CGSizeEqualToSize(CGSize(width: 640, height: 960), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))
//iphone5系列
let iPhone5:Bool = __CGSizeEqualToSize(CGSize(width: 640, height: 1136), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))
//iphone6、7、8系列
let iPhone6:Bool = __CGSizeEqualToSize(CGSize(width: 750, height: 1334), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))
//iphone6+、7+、8+系列
let iPhone6Plus:Bool = __CGSizeEqualToSize(CGSize(width: 1242, height: 2208), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))
// iPhoneXR
let iPhoneXR:Bool = __CGSizeEqualToSize(CGSize(width: 828, height: 1792), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

// iPhoneX、iPhoneXs
let iPhoneX:Bool = __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

// iPhoneXSMAX
let iPhoneXSMAX:Bool = __CGSizeEqualToSize(CGSize(width: 1242, height: 2688), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0))

//判断是否iphone
let isPhone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)

//判断是否ipad
let isPad = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

/// 获取设备版本号
func deviceName() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
    case "iPod5,1":                                 return "iPod Touch 5"
    case "iPod7,1":                                 return "iPod Touch 6"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
    case "iPhone4,1":                               return "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
    case "iPhone7,2":                               return "iPhone 6"
    case "iPhone7,1":                               return "iPhone 6 Plus"
    case "iPhone8,1":                               return "iPhone 6s"
    case "iPhone8,2":                               return "iPhone 6s Plus"
    case "iPhone9,1":                               return "iPhone 7 (CDMA)"
    case "iPhone9,3":                               return "iPhone 7 (GSM)"
    case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
    case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
        
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
    case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
    case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
    case "iPad6,7", "iPad6,8":                      return "iPad Pro"
    case "AppleTV5,3":                              return "Apple TV"
    case "i386", "x86_64":                          return "Simulator"
    default:                                        return identifier
    }
}

func appendUrl(url : String) -> String {
    if url.count == 0 {
        return ""
    }
    if url.contains("http") {
        return url
    }
    return AppConstants.requestUrl + url
}
