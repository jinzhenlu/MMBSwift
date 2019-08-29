//
//  LoginViewController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/7/31.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit
import MBProgressHUD
import HandyJSON


class LoginViewController: BaseViewController {

    var txt_name: UITextField?
    var txt_password: UITextField?
    var txt_code: UITextField?
    var btn_sendCode: UIButton?
    var btn_done: UIButton?
    var btn_forgetPassword: UIButton?
    var btn_register: UIButton?
    var rightbar: UIButton?
    //是否验证码登录（默认密码登录）
    var login_with_code :Bool = false
    
    var myTimer: ZJTimer!
    var time: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "登录"
        self.initialize()
    }
    
    deinit{
        if myTimer != nil {
            myTimer.invalidate()
            myTimer = nil
        }
    }
}

//MARK:selector
extension LoginViewController{
    @objc private func registerClick(){
        let registerController = RegisterViewController()
        self.navigationController?.pushViewController(registerController, animated: true)
    }
    
    @objc private func findPassword(){
        let findpasswordController = FindPasswordViewController(nibName: "FindPasswordViewController", bundle: nil)
        findpasswordController.title = "找回密码"
        self.navigationController?.pushViewController(findpasswordController, animated: true)
    }
    
    @objc private func rightBarClick(){
        login_with_code = !login_with_code
        if login_with_code {
            txt_password?.isHidden = true
            txt_code?.isHidden = false
            btn_sendCode?.isHidden = false
        }else{
            txt_password?.isHidden = false
            txt_code?.isHidden = true
            btn_sendCode?.isHidden = true
        }
        
    }
    
    @objc private func getAuthCode(){
        if checkMobile(txt_name!.text! as NSString) {
            NetWorkRequest(.getVerifyCode(telphone: txt_name!.text!), completion: { (resultString) -> (Void) in
                let model : HeadModel = jsonToModel(resultString, HeadModel.self) as! HeadModel
                if model.head.code == 200 {
                    self.time = 60
                    self.myTimer = ZJTimer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                }
            }, failed: { (str) -> (Void) in
                
            }) { () -> (Void) in
                
            }
        }else{
            CBToast.showToastAction(message: "请输入正确的手机号")
        }
    }
    
    @objc private func countDown(){
        self.time -= 1
        if time > 0 {
            btn_sendCode?.setTitle(NSString(format: "%d秒", time) as String, for: .normal)
            btn_sendCode?.isEnabled = false
        }else{
            btn_sendCode?.setTitle("获取验证码", for: .normal)
            btn_sendCode?.isEnabled = true
            myTimer.invalidate()
            myTimer = nil
        }
    }
    
    @objc private func loginClick(){
        if checkMobile(txt_name!.text! as NSString) {
            if login_with_code {
                if txt_code!.text!.count == 0 {
                    CBToast.showToastAction(message: "验证码不能为空")
                }else{
                    self.loginWithCode()
                }
            }else{
                if txt_password!.text!.count == 0 {
                    CBToast.showToastAction(message: "密码不能为空")
                }else{
                    self.loginWithPassword()
                }
            }
        }else{
            CBToast.showToastAction(message: "请输入正确的手机号")
        }
    }
    
    private func loginWithCode(){
        self.view.endEditing(true)
        let params = ["telphone":txt_name!.text!,"cmd":txt_code!.text!,"deivceid":"ios","imei1":UIDevice.current.identifierForVendor?.uuidString,"tel_type":deviceName()]
        NetWorkRequest(.loginByCmd(params: params as [String : Any]), completion: { [weak self](jsonString) -> (Void) in
            let model:LoginModel = jsonToModel(jsonString, LoginModel.self) as! LoginModel
            if model.head.code == 200 {
                self?.setUserDefaults(model: model.body)
            }else{
                CBToast.showToastAction(message: model.head!.msg! as NSString)
            }
            }, failed: { (str) -> (Void) in
                
        }) { () -> (Void) in
            
        }
        
    }
    
    private func loginWithPassword(){
        self.view.endEditing(true)
        let password = txt_password!.text! + ".*.-"
        let md5_psw = password.md5()
        let md5_psw_2 = md5_psw.md5()
        let body = LoginBody()
        body.user_name = txt_name!.text!
        body.password = md5_psw_2
        body.deivceid = "ios"
        body.imei1 = UIDevice.current.identifierForVendor?.uuidString
        body.tel_type = deviceName()
        let params = modelToDictionary(body)
        //        weak var weakSelf = self
        NetWorkRequest(.login(paramters: params as [String : Any]), completion: { [weak self](jsonString) -> (Void) in
            let model:LoginModel = jsonToModel(jsonString, LoginModel.self) as! LoginModel
            if model.head.code == 200 {
                self?.setUserDefaults(model: model.body)
            }else{
                CBToast.showToastAction(message: model.head!.msg! as NSString)
            }
            }, failed: { (str) -> (Void) in
                
        }) { () -> (Void) in
            
        }
    }
    
    private func setUserDefaults(model : LoginObject){
        
        let dict : NSMutableDictionary = NSMutableDictionary.init()
        dict.setValue(model.sid, forKey: "userId")
        dict.setValue(model.sid, forKey: "sid")
        dict.setValue(model.bid, forKey: "bid")
        dict.setValue(model.token, forKey: "token")
        dict.setValue(model.person_id, forKey: "personId")
        dict.setValue(model.person_name, forKey: "personName")
        dict.setValue(model.person_tel, forKey: "personTel")
        dict.setValue(model.owner_id, forKey: "ownerId")
        dict.setValue(model.name, forKey: "name")
        dict.setValue(model.user_name, forKey: "userName")
        dict.setValue(model.nick_name, forKey: "im_nick")
        dict.setValue(model.avatarUrl, forKey: "avatar")
        dict.setValue(model.customer_type_id, forKey: "customer_type_id")
        dict.setValue(model.supplier_type_id, forKey: "supplier_type_id")
        dict.setValue(model.mobile, forKey: "mobile")
        dict.setValue(txt_name?.text, forKey: "user_account")
        dict.setValue(txt_password?.text, forKey: "password")
        dict.setValue(model.isCustomerAdmin, forKey: "isCustomerAdmin")
        dict.setValue(model.isSupAdmin, forKey: "isSupAdmin")
        var station : String
        switch Int(model.station!) {
        case 1:
            station = "司机"
        case 2:
            station = "厨师"
        case 3:
            station = "采购"
        case 4:
            station = "财务"
        case 5:
            station = "库管"
        case 6:
            station = "小工"
        case 7:
            station = "开单员"
        case 8:
            station = "销售"
        default:
            station = ""
        }
        dict.setValue(station, forKey: "station")
        UserDefaults.AccountInfo.set(value: dict, forKey: .userInfo)
        UIApplication.shared.keyWindow?.rootViewController = XHTabbar()
    }
}

//MARK:初始化
extension LoginViewController{
    
    fileprivate func initialize() {
        
//        self.backBarItem = nil
        
        rightbar = UIButton(type: .custom)
        rightbar?.setTitle("验证码登录", for: .normal)
        rightbar?.setTitleColor(.white, for: .normal)
        rightbar?.titleLabel?.font = FONT(font: 13)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbar!)
        rightbar?.addTarget(self, action: #selector(rightBarClick), for: .touchUpInside)
        
        txt_name = UITextField()
        txt_name?.placeholder = "  账号"
        txt_name?.font = FONT(font: 15)
        txt_name?.backgroundColor = AppColor.lightGray2
        txt_name?.layer.masksToBounds = true
        txt_name?.layer.cornerRadius = 8
        txt_name?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txt_name?.keyboardType = UIKeyboardType.phonePad
        self.view.addSubview(txt_name!)
        
        txt_name?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(AppFrame.kHeight_StatusBarAndNavigationBar+30)
            make.height.equalTo(45)
        })
        
        txt_password = UITextField()
        txt_password?.placeholder = "  密码"
        txt_password?.font = FONT(font: 15)
        txt_password?.backgroundColor = AppColor.lightGray2
        txt_password?.layer.masksToBounds = true
        txt_password?.layer.cornerRadius = 8
        txt_password?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txt_password?.isSecureTextEntry = true
        self.view.addSubview(txt_password!)
        
        txt_password?.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(txt_name!)
            make.top.equalTo(txt_name!.snp.bottom).offset(20)
        })
        
        txt_code = UITextField()
        txt_code?.placeholder = "  验证码"
        txt_code?.font = FONT(font: 15)
        txt_code?.backgroundColor = AppColor.lightGray2
        txt_code?.layer.masksToBounds = true
        txt_code?.layer.cornerRadius = 8
        self.view.addSubview(txt_code!)
        txt_code?.isHidden = true
        txt_code?.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        txt_code?.keyboardType = UIKeyboardType.numberPad
        txt_code?.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(txt_password!)
            make.right.equalTo(self.view).offset(-120)
        })
        
        btn_sendCode = UIButton(type: .custom)
        btn_sendCode?.setTitleColor(AppColor.blue, for: .normal)
        btn_sendCode?.layer.masksToBounds = true
        btn_sendCode?.layer.cornerRadius = 5
        btn_sendCode?.layer.borderWidth = 0.5
        btn_sendCode?.layer.borderColor = AppColor.blue.cgColor
        btn_sendCode?.setTitle("获取验证码", for: .normal)
        btn_sendCode?.titleLabel?.font = FONT(font: 14)
        btn_sendCode?.isHidden = true
        btn_sendCode?.addTarget(self, action: #selector(getAuthCode), for: .touchUpInside)
        self.view.addSubview(btn_sendCode!)
        btn_sendCode?.snp.makeConstraints({ (make) in
            make.right.equalTo(txt_name!)
            make.centerY.equalTo(txt_code!)
            make.left.equalTo(txt_code!.snp.right).offset(20)
            make.height.equalTo(35)
        })
        
        btn_done = UIButton(type: .custom)
        btn_done?.backgroundColor = AppColor.blue
        btn_done?.setTitle("登录", for: .normal)
        btn_done?.titleLabel?.font = FONT(font: 16)
        btn_done?.setTitleColor(.white, for: .normal)
        btn_done?.layer.masksToBounds = true
        btn_done?.layer.cornerRadius = 8
        btn_done?.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        self.view.addSubview(btn_done!)
        btn_done?.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(txt_name!)
            make.top.equalTo(txt_password!.snp.bottom).offset(30)
        })
        
        btn_forgetPassword = UIButton(type: .custom)
        btn_forgetPassword?.setTitleColor(AppColor.blue, for: .normal)
        btn_forgetPassword?.setTitle("找回密码", for: .normal)
        btn_forgetPassword?.titleLabel?.font = FONT(font: 14)
        self.view.addSubview(btn_forgetPassword!)
        btn_forgetPassword?.addTarget(self, action: #selector(findPassword), for: .touchUpInside)
        btn_forgetPassword?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(btn_done!.snp.bottom).offset(25)
            make.height.equalTo(30)
            make.width.equalTo(80)
        })
        
        btn_register = UIButton(type: .custom)
        btn_register?.setTitleColor(AppColor.blue, for: .normal)
        btn_register?.setTitle("没有账号？立即注册", for: .normal)
        btn_register?.titleLabel?.font = FONT(font: 14)
        self.view.addSubview(btn_register!)
        btn_register?.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        btn_register?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.view).offset(-30)
            make.height.top.equalTo(btn_forgetPassword!)
        })
        
    }
}

