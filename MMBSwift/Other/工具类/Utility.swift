//
//  Utility.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/5.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation

func logout(){
    UserDefaults.AccountInfo.remove(forKey: .userInfo)
}
