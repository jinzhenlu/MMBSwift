//
//  RegularVerify.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/5.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//  正则验证

import Foundation

//MARK:验证邮箱
func validateEmail(email: String) -> Bool {
    if email.count == 0 {
        return false
    }
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}

//MARK:- 正则匹配URL
func checkURL(_ url:NSString) ->Bool {
    let pattern = "^[0-9A-Za-z]{1,50}"
    let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
    let isMatch:Bool = pred.evaluate(with: url)
    return isMatch;
}

//MARK:验证手机号
func isPhoneNumber(phoneNumber:String) -> Bool {
    if phoneNumber.count == 0 {
        return false
    }
    let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    if regexMobile.evaluate(with: phoneNumber) == true {
        return true
    }else
    {
        return false
    }
}

//MARK:- 正则匹配手机号
func checkMobile(_ mobileNumbel:NSString) ->Bool
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    let MOBIL = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    let CM = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    let CU = "^((13[0-2])|(145)|(15[5-6])|16[0-9]|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,181(增加)
     */
    let CT = "^((133)|(153)|(170)|(173)|(177)|(18[0,1,9]))\\d{8}$";
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBIL)
    let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM)
    let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)
    let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)
    if regextestmobile.evaluate(with: mobileNumbel)||regextestcm.evaluate(with: mobileNumbel)||regextestcu.evaluate(with: mobileNumbel)||regextestct.evaluate(with: mobileNumbel) {
        return true
    }
    return false
}

//MARK:密码正则  6-8位字母和数字组合
func isPasswordRuler(password:String) -> Bool {
    let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
    let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
    if regexPassword.evaluate(with: password) == true {
        return true
    }else
    {
        return false
    }
}

//MARK:- 正则匹配用户身份证号15或18位
func checkUserIdCard(_ idCard:NSString) ->Bool {
    let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
    let isMatch:Bool = pred.evaluate(with: idCard)
    return isMatch;
}

//MARK:验证身份证号
func isTrueIDNumber(text:String) -> Bool{
    var value = text
    value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    var length : Int = 0
    length = value.count
    if length != 15 && length != 18{
        //不满足15位和18位，即身份证错误
        return false
    }
    // 省份代码
    let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
    // 检测省份身份行政区代码
    let index = value.index(value.startIndex, offsetBy: 2)
    //    let valueStart2 = value.substring(to: index)
    let valueStart2 = String(value[..<index])
    
    
    //标识省份代码是否正确
    var areaFlag = false
    for areaCode in areasArray {
        if areaCode == valueStart2 {
            areaFlag = true
            break
        }
    }
    if !areaFlag {
        return false
    }
    var regularExpression : NSRegularExpression?
    var numberofMatch : Int?
    var year = 0
    switch length {
    case 15:
        //获取年份对应的数字
        let valueNSStr = value as NSString
        let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
        year = yearStr.integerValue + 1900
        if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
            //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
            //测试出生日期的合法性
            regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
        }else{
            //测试出生日期的合法性
            regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
        }
        numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
        if numberofMatch! > 0 {
            return true
        }else{
            return false
        }
    case 18:
        let valueNSStr = value as NSString
        let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
        year = yearStr.integerValue
        if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
            //测试出生日期的合法性
            regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
            
        }else{
            //测试出生日期的合法性
            regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
            
        }
        numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
        
        if numberofMatch! > 0 {
            let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
            let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
            let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
            let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
            let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
            let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
            let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
            let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
            let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
            let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
            let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
            let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
            let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
            let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
            let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
            let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
            let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
            let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
            
            let Y = S % 11
            
            var M = "F"
            
            let JYM = "10X98765432"
            
            M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
            
            let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
            
            if lastStr == "x" {
                if M == "X" {
                    return true
                }else{
                    return false
                }
            }else{
                if M == lastStr {
                    return true
                }else{
                    return false
                }
            }
            
        }else{
            return false
        }
    default:
        return false
    }
}

func getStringByRangeIntValue(Str : NSString,location : Int, length : Int) -> Int{
    
    let a = Str.substring(with: NSRange(location: location, length: length))
    
    let intValue = (a as NSString).integerValue
    
    return intValue
}

//MARK:判断仅输入字母或数字（17位）：(用于判断车架号)
func isOnlyContainsLetterOrNumber(string: String) -> Bool {
    if string.count == 0 {
        return false
    }
    
    let regex = "[a-zA-Z0-9]{17}$"
    let regexString = NSPredicate(format: "SELF MATCHES %@", regex)
    return regexString.evaluate(with: string)
}
