//
//  MXResponseTool.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/7.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit
import HandyJSON

class MXResponseTool: HandyJSON {

    var head:MXResponseHeader?
    
    required init(){}
    
}
class MXResponseHeader: HandyJSON {
    var code:Int = 0
    var msg:String = ""
    var version:String = ""
    var time:String = ""
    required init(){}
}
