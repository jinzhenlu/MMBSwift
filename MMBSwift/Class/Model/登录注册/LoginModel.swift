//
//  LoginModel.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/8.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class LoginModel: MMBBaseModel {
    var head : Header!
    var body : LoginObject!
}

class LoginObject: MMBBaseModel {
    var sid : String?
    var bid : String?
    var token : String = ""
    //主账号名称（可能与公司名一致，但是可以单独更改）
    var name : String!
    //公司名
    var user_name : String?
    var avatarUrl : String?
    var address : String?
    //职员id
    var person_id : String?
    //职员姓名
    var person_name : String?
    //职员手机号
    var person_tel : String?
    //主账户id
    var owner_id : String?
    //职员岗位(空值则直接显示职员）
    var station : String?
    //融云token值
    var r_token : String?
    //设置的IM里显示的昵称
    var nick_name : String?
    //融云头像
    var r_head_img : String?
    //客户维度分类id
    var customer_type_id : String?
    //客户维度分类名称
    var customer_type_name : String?
    //供应商维度分类id
    var supplier_type_id : String?
    //供应商维度分类名称
    var supplier_type_name : String?
    var mobile : String?
    //是否客户分类管理员 1：是 0:否
    var isCustomerAdmin : String?
    //是否供应商分类管理员 1：是 0:否
    var isSupAdmin : String?
}
/*
 密码登录：user_name、password、deivceid、tel_type、imei1
 验证码登录：telphone、cmd、deivceid、tel_type、imei1
 注册：telphone、password、cmd、deivceid
 修改密码：telphone、password、cmd、mid(忘记密码，账号找回密码时不传；登录状态更改密码时，必传)
 验证原手机号：telphone、cmd、sup_id
 绑定新手机号：telphone、cmd、sup_id、new_telphone
 */
class LoginBody: MMBBaseModel {
    var user_name : String?
    var password : String?
    var deivceid : String?
    var tel_type : String?
    var imei1 : String?
    var telphone : String?
    var cmd : String?
    
    //主账户id （忘记密码，账号找回密码时不传；登录状态更改密码时，必传）
    var mid : String?
    //验证原手机号传
    var sup_id : String?
    //绑定新手机号传
    var new_telphone : String?
}
