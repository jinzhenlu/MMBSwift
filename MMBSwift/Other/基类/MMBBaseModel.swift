//
//  MMBBaseModel.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/7.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit
import HandyJSON

class MMBBaseModel: HandyJSON {

    required public init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        
    }
}

class Header: HandyJSON {
    
    var code : Int!
    var msg : String!
    var time : String!
    var version : String!
    
    required init() {
        
    }
}

class HeadModel: MMBBaseModel {
    var head : Header!
    
}
