//
//  AppDelegate.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/7/29.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        let login = LoginViewController()
        let userInfo = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
        if userInfo != nil {
            window?.rootViewController = XHTabbar()
        }else{
            window?.rootViewController = MMBNavigationController(rootViewController: login)//XHTabbar()
        }
        self.setNavbar()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setNavbar(){
        UINavigationBar.appearance().barTintColor = RGBA(r: 37, g: 37, b: 37, a: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

