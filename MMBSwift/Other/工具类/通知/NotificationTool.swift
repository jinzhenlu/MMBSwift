//
//  NotificationTool.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/29.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

protocol Notifier {
    associatedtype NotificationName : RawRepresentable
}

extension Notifier where NotificationName.RawValue == String {
    static func nameFor(notification : NotificationName) -> String{
        return "\(notification.rawValue)"
    }
    
    /// 发送通知
    static func post(notification: NotificationName, object:AnyObject? = nil) {
        
        let name = nameFor(notification: notification)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
    }
    
    /// 增加观察 - 接收通知
    static func add(observer: AnyObject, selector: Selector, notification: NotificationName, object:AnyObject? = nil) {
        
        let name = nameFor(notification: notification)
        NotificationCenter.default
            .addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    /// 移除观察 - 移除通知
    static func remove(observer: AnyObject, notification: NotificationName, object:AnyObject? = nil) {
        
        let name = nameFor(notification: notification)
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    static func remove(observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
}

class NotificationTool: Notifier {
    enum NotificationName : String {
        //刷新个人中心页面
        case refreshPersonView
    }
}
