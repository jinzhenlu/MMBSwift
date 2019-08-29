//
//  SupInfoModel.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/28.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class SupInfoModel: MMBBaseModel {
    var datas : SupInfoObject!
}

class SupInfoJsonModel: MMBBaseModel {
    var head : Header!
    var body : SupInfoModel!
}

class SupInfoObject: MMBBaseModel {
    //全称
    var user_name : String?
    //全称
    var shop_name : String?
    //简称
    var name : String?
    //简称
    var user_shortname : String?
    //
    var telphone : String?
    //
    var r_head_img : String?
    //
    var avatarUrl : String?
    //
    var head_url : String?
    //小程序职员码
    var personimage_url : String?
    //小程序揽客码
    var watimage_url : String?
    //小程序职员码(展示用)
    var personimage : String?
    //小程序揽客码(展示用)
    var watimage : String?
    //
    var endPath_purchase : String?
    //
    var endWatImage_small_purchase : String?
    
    var account : [AccountInfo]!
}

class AccountInfo: MMBBaseModel {
    //公司账户id
    var id : String?
    var bid : String?
    var sid : String?
    var owner_id : String?
    //公司账户名称
    var account_name : String?
    //开户行
    var account_bank : String?
    //银行卡号
    var account_num : String?
    //结算账户凭证
    var account_img : String?
    //银行名
    var the_bank : String?
    //
    var type : String?
    //
    var is_default : String?
    //
    var add_time : String?
    //
    var account_code : String?
}

