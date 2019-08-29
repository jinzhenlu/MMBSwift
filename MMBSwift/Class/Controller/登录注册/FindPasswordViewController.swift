//
//  FindPasswordViewController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/20.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class FindPasswordViewController: BaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var btnCmd: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    
    var isLogin : Bool = false
    
    var myTimer: ZJTimer!
    var time: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
    }

    deinit{
        if myTimer != nil {
            myTimer.invalidate()
            myTimer = nil
        }
    }
    
}

extension FindPasswordViewController {
    
    @objc private func getAuthCode(){
        if checkMobile(txtName!.text! as NSString) {
            NetWorkRequest(.getVerifyCode(telphone: txtName!.text!), completion: { (resultString) -> (Void) in
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
            btnCmd?.setTitle(NSString(format: "%d秒", time) as String, for: .normal)
            btnCmd?.isEnabled = false
        }else{
            btnCmd?.setTitle("获取验证码", for: .normal)
            btnCmd?.isEnabled = true
            myTimer.invalidate()
            myTimer = nil
        }
    }
    
    @objc private func doneClick(){
        if txtName?.text?.count == 0 || txtCode?.text?.count == 0 || txtPassword?.text?.count == 0 {
            CBToast.showToastAction(message: "请正确填写所有信息")
            return
        }
        if (txtPassword?.text!.count)! < 6 {
            CBToast.showToastAction(message: "密码不能少于6位")
            return
        }
        self.view.endEditing(true)
        let password = txtPassword!.text! + ".*.-"
        let md5_psw = password.md5()
        let md5_psw_2 = md5_psw.md5()
        var mid = ""
        if isLogin {
            let user_info = UserDefaults.AccountInfo.dictionary(forKey: .userInfo)
            if user_info != nil {
                mid = user_info!["personId"] as? String ?? ""
                if mid.count == 0 {
                    mid = user_info!["ownerId"] as? String ?? ""
                }
            }
        }
        let body = LoginBody()
        body.telphone = txtName?.text
        body.password = md5_psw_2
        body.mid = mid
        body.cmd = txtCode?.text
        
        let params = modelToDictionary(body)
        NetWorkRequest(.changPassword(params: params), completion: { [weak self](jsonString) -> (Void) in
            let model : HeadModel = jsonToModel(jsonString, HeadModel.self) as! HeadModel
            CBToast.showToastAction(message: model.head!.msg! as NSString)
            if model.head.code == 200 {
                self?.navigationController?.popViewController(animated: true)
            }
        }) { (failString) -> (Void) in
            
        }
    }
    private func initialize(){
        topConstraint.constant = CGFloat(AppFrame.kHeight_StatusBarAndNavigationBar + 30)
        
        txtName.layer.masksToBounds = true
        txtName.layer.cornerRadius = 8
        txtName.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        
        txtCode.layer.masksToBounds = true
        txtCode.layer.cornerRadius = 8
        txtCode.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        
        btnCmd.layer.masksToBounds = true
        btnCmd.layer.cornerRadius = 5
        btnCmd.layer.borderWidth = 0.5
        btnCmd.layer.borderColor = AppColor.blue.cgColor
        btnCmd.addTarget(self, action: #selector(getAuthCode), for: .touchUpInside)
        
        txtPassword.layer.masksToBounds = true
        txtPassword.layer.cornerRadius = 8
        txtPassword.setValue(NSNumber(value: 10), forKey: "paddingLeft")
        
        btnDone.layer.masksToBounds = true
        btnDone.layer.cornerRadius = 8
        btnDone.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
    }
}
